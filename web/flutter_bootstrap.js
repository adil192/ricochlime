{{flutter_js}}
{{flutter_build_config}}

/* The overlay shown when loading */
const loading = document.getElementById('loading');

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();

    // Remove the loading spinner when the app runner is ready
    loading.classList.add('loaded');

    await appRunner.runApp();
  }
});
