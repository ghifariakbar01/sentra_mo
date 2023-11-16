part of style;

mixin Themes {
  static void initUiOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Palette.primaryColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.light(
        primary: Palette.primaryColor,
        secondary: Palette.primaryColor,
        onSecondary: Palette.secondaryTextColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static InputDecoration formStyle({String? hint, Icon? icon}) {
    return InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        prefixIcon: icon ?? const Icon(Icons.person),
        labelText: hint,
        labelStyle: Themes.custom(color: Colors.black, fontSize: 14));
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.dark(
        primary: Palette.primaryColor,
        secondary: Palette.secondaryColor,
        onPrimary: Palette.primaryTextColor,
        onSecondary: Palette.secondaryTextColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static TextStyle custom(
      {Color? color, FontWeight? fontWeight, double? fontSize}) {
    return GoogleFonts.poppins(
        color: color ?? Colors.white,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 12);
  }

  static TextStyle whiteText() {
    return const TextStyle().copyWith(
      color: Colors.white,
    );
  }

  static TextStyle greenText() {
    return const TextStyle().copyWith(
      color: Colors.black,
    );
  }
}
