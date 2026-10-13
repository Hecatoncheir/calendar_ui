#!/usr/bin/env python3
"""Проверка версии и подготовка файлов релиза без сторонних зависимостей."""

import argparse
import hashlib
import os
from pathlib import Path
import re
import shutil
import subprocess


def release_metadata(root, ref):
    pubspec = (root / "pubspec.yaml").read_text()
    name = re.search(r"^name: (\S+)\s*$", pubspec, re.MULTILINE).group(1)
    version = re.search(r"^version: (\S+)\s*$", pubspec, re.MULTILINE).group(1)
    if not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version):
        raise ValueError("Версия релиза должна иметь формат X.Y.Z")
    tag = f"v{version}"
    if ref.startswith("refs/tags/") and ref != f"refs/tags/{tag}":
        raise ValueError(f"Тег {ref} не соответствует версии {version}")
    changelog = (root / "CHANGELOG.md").read_text()
    section = re.search(
        rf"^## {re.escape(version)}(?: - [0-9]{{4}}-[0-9]{{2}}-[0-9]{{2}})?\s*\n(.*?)(?=^## |\Z)",
        changelog,
        re.MULTILINE | re.DOTALL,
    )
    if section is None or not section.group(1).strip():
        raise ValueError(f"В CHANGELOG.md нет описания версии {version}")
    return name, version, tag, section.group(1).strip() + "\n"


def prepare_archive(root, name, tag, notes):
    destination = root / "dist"
    destination.mkdir(exist_ok=True)
    for path in destination.iterdir():
        if path.is_file():
            path.unlink()
    (destination / "RELEASE_NOTES.md").write_text(notes)
    subprocess.run(
        ["git", "archive", "--format=tar.gz", f"--prefix={name}-{tag}/",
         "-o", str(destination / f"{name}-{tag}-source.tar.gz"), "HEAD"],
        cwd=root, check=True,
    )
    for view in ("month", "week"):
        web = root / "example" / "build" / "release" / view
        if name == "calendar_ui" and not (web / "index.html").is_file():
            raise ValueError(f"Не собран web-пример {view}")
        if name == "calendar_ui":
            shutil.make_archive(str(destination / f"{name}-{tag}-{view}-web"), "zip", web)
    sums = [
        f"{hashlib.sha256(path.read_bytes()).hexdigest()}  {path.name}"
        for path in sorted(destination.iterdir()) if path.is_file()
    ]
    (destination / "SHA256SUMS").write_text("\n".join(sums) + "\n")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Проверить без создания архивов")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    name, version, tag, notes = release_metadata(root, os.environ.get("GITHUB_REF", ""))
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as stream:
            stream.write(f"version={version}\ntag={tag}\n")
    if not args.check:
        prepare_archive(root, name, tag, notes)
    print(f"{name}: {tag}, CHANGELOG проверен")


if __name__ == "__main__":
    main()
