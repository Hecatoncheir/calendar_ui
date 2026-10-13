"""Проверки правил публикации и состава релизных архивов."""

import hashlib
from pathlib import Path
import subprocess
import tarfile
import tempfile
import unittest
import zipfile

from prepare_release import prepare_archive, release_metadata


class ReleaseTests(unittest.TestCase):
    def setUp(self):
        self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        self.root = Path(self.directory.name)
        self.write_package()

    def write_package(self, name="calendar", version="0.3.1"):
        (self.root / "pubspec.yaml").write_text(f"name: {name}\nversion: {version}\n")
        (self.root / "CHANGELOG.md").write_text(
            f"# История\n\n## {version} - 2026-10-13\n\n- Изменение.\n\n## 0.3.0\n\n- Старое.\n"
        )

    def commit(self):
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        subprocess.run(["git", "add", "."], cwd=self.root, check=True)
        subprocess.run(
            ["git", "-c", "user.name=CI", "-c", "user.email=ci@example.invalid",
             "commit", "-qm", "fixture"], cwd=self.root, check=True,
        )

    def test_branch_extracts_only_current_notes(self):
        name, version, tag, notes = release_metadata(self.root, "refs/heads/main")
        self.assertEqual((name, version, tag), ("calendar", "0.3.1", "v0.3.1"))
        self.assertEqual(notes, "- Изменение.\n")

    def test_matching_tag(self):
        self.assertEqual(release_metadata(self.root, "refs/tags/v0.3.1")[2], "v0.3.1")

    def test_mismatched_tag_is_rejected(self):
        with self.assertRaises(ValueError):
            release_metadata(self.root, "refs/tags/v0.3.2")

    def test_non_release_version_is_rejected(self):
        self.write_package(version="invalid")
        with self.assertRaises(ValueError):
            release_metadata(self.root, "")

    def test_missing_changelog_section_is_rejected(self):
        (self.root / "CHANGELOG.md").write_text("## 0.3.0\n\n- Старое.\n")
        with self.assertRaises(ValueError):
            release_metadata(self.root, "")

    def test_empty_changelog_section_is_rejected(self):
        (self.root / "CHANGELOG.md").write_text("## 0.3.1\n\n## 0.3.0\n- Старое.\n")
        with self.assertRaises(ValueError):
            release_metadata(self.root, "")

    def test_source_archive_and_checksums(self):
        self.commit()
        prepare_archive(self.root, "calendar", "v0.3.1", "- Изменение.\n")
        dist = self.root / "dist"
        with tarfile.open(dist / "calendar-v0.3.1-source.tar.gz") as archive:
            self.assertIn("calendar-v0.3.1/pubspec.yaml", archive.getnames())
        for line in (dist / "SHA256SUMS").read_text().splitlines():
            digest, name = line.split("  ")
            self.assertEqual(digest, hashlib.sha256((dist / name).read_bytes()).hexdigest())

    def test_ui_requires_both_web_builds(self):
        self.commit()
        with self.assertRaises(ValueError):
            prepare_archive(self.root, "calendar_ui", "v0.5.1", "- Изменение.\n")

    def test_ui_packages_both_web_builds(self):
        self.commit()
        for view in ("month", "week"):
            directory = self.root / "example" / "build" / "release" / view
            directory.mkdir(parents=True)
            (directory / "index.html").write_text(view)
        prepare_archive(self.root, "calendar_ui", "v0.5.1", "- Изменение.\n")
        for view in ("month", "week"):
            with zipfile.ZipFile(self.root / "dist" / f"calendar_ui-v0.5.1-{view}-web.zip") as archive:
                self.assertEqual(archive.read("index.html").decode(), view)
