{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load(
    {
        onEntrypointLoaded: async function(engineInitializer) {
            // Initialize the Flutter engine
            let appRunner = await engineInitializer.initializeEngine({});
            // Run the app
            await appRunner.runApp();
          }
    }
);
