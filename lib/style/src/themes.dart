part of style;

mixin Themes {
  static void initUiOverlayStyle(ThemeMode mode) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: mode.index == 0 ? Palette.primaryColor : Colors.black,
      // statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      // systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  static OutlineInputBorder notFocused({
    required bool isRadius,
    Color? borderColor,
  }) {
    return OutlineInputBorder(
        borderRadius: isRadius
            ? const BorderRadius.all(Radius.circular(10))
            : const BorderRadius.all(Radius.zero),
        borderSide: BorderSide(color: borderColor ?? Colors.black));
  }

  static OutlineInputBorder focused() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Palette.primaryColor));
  }

  static TextStyle greyHint(FontWeight fontWeight, double fontSize,
      {Color? color}) {
    return GoogleFonts.lato(
      color: color ?? Palette.grey,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static InputDecoration formStyle(String hintText,
      {Widget? icon, double? hintFontSize, Color? color}) {
    return InputDecoration(
      border: InputBorder.none,
      enabledBorder: Themes.notFocused(isRadius: true, borderColor: color),
      focusedBorder: Themes.focused(),
      contentPadding: const EdgeInsets.all(16),
      hintStyle:
          Themes.greyHint(FontWeight.normal, color: color, hintFontSize ?? 16),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
      prefixIcon: icon,
      hintText: hintText,
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Palette.primaryColor,
      colorScheme: const ColorScheme.light(
        primaryContainer: Colors.white,
        secondaryContainer: Palette.primaryColor,
        tertiaryContainer: Palette.greyDisabled,
        primary: Palette.primaryColor,
        secondary: Colors.black,
        tertiary: Colors.black,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
      appBarTheme: AppBarTheme(
          titleTextStyle: Themes.greyHint(
              FontWeight.normal, color: Palette.primaryColor, 20),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Palette.primaryColor)),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white)),
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.black,
      colorScheme: const ColorScheme.light(
        primaryContainer: Colors.black,
        secondaryContainer: Colors.black,
        tertiaryContainer: Colors.black,
        primary: Colors.white,
        secondary: Colors.black,
        tertiary: Colors.white,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }
}
