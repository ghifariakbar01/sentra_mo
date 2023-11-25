part of configuration;

abstract class Env {
  Env() {
    _init();
  }

  void _init() {
    if (kReleaseMode) {
      // Used to prevent printing in release mode
      debugPrint = (String? message, {int? wrapWidth}) {};
    }

    runZonedGuarded(() async {
      WidgetsFlutterBinding.ensureInitialized();

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

      BuildConfig.init(flavor: const String.fromEnvironment('flavor'));

      HttpOverrides.global = MyHttpOverrides();

      Themes.initUiOverlayStyle(ThemeMode.system);

      usePathUrlStrategy();

      final app = await onCreate();

      runApp(
        ProviderScope(
          child: app,
        ),
      );
    }, (obj, stack) {
      debugPrint(obj.toString());
      debugPrint(stack.toString());
    });
  }

  FutureOr<HookConsumerWidget> onCreate();
}
