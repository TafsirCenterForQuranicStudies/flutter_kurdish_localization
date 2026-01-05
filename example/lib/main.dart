import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kurdish_localization/flutter_kurdish_localization.dart';
import 'package:flutter_kurdish_localization_example/localization/demo_localization.dart';
import 'package:flutter_kurdish_localization_example/localization/language_constants.dart';
import 'package:flutter_kurdish_localization_example/router/custom_router.dart';
import 'package:flutter_kurdish_localization_example/router/route_constants.dart';
import 'package:flutter_kurdish_localization_example/util/constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool landingScreen = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  landingScreen = prefs.getBool('landing') ?? false;

  debugPrint('Landing : $landingScreen');

  runApp(const MyApp());
}

const List<Locale> supportedLocales = [
  Locale('en'),
  Locale('ckb'),
  Locale('ar'),
];

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  static void setLocale(BuildContext context, Locale newLocale) {
    final state = context.findAncestorStateOfType<MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (!mounted) return;
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent, // NavigationBar Color
        statusBarColor: primaryColor, // StatusBar Color
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Multi Localization Demo",
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      locale: _locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        DemoLocalization.delegate,
        KurdishCupertinoLocalizationsDelegate(),
        KurdishMaterialLocalizations.delegate,
        KurdishWidgetLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      onGenerateRoute: CustomRouter.generatedRoute,
      initialRoute: landingScreen ? homeRoute : landingRoute,
    );
  }
}
