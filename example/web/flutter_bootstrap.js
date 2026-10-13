{{flutter_js}}
{{flutter_build_config}}

async function removeDeprecatedFlutterServiceWorkers() {
  if (!('serviceWorker' in navigator)) {
    return;
  }

  const registrations = await navigator.serviceWorker.getRegistrations();
  const flutterRegistrations = registrations.filter((registration) => {
    const workers = [
      registration.active,
      registration.waiting,
      registration.installing,
    ];

    return workers.some((worker) =>
      worker?.scriptURL.includes('/flutter_service_worker.js'),
    );
  });

  await Promise.all(
    flutterRegistrations.map((registration) => registration.unregister()),
  );
}

removeDeprecatedFlutterServiceWorkers()
  .catch((error) => {
    console.warn('Unable to remove the legacy Flutter service worker.', error);
  })
  .then(() => _flutter.loader.load());
