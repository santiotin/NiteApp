import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Ui/Login/SplashPage.dart';
import 'Utils/Constants.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: isDark ? Constants.darkPrimary : Constants.lightPrimary,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }


  @override
  Widget build(BuildContext context) {

    FirebaseAnalytics analytics = FirebaseAnalytics();

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          // ... app-specific localization delegate[s] here
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es'), // Spanish
          // ... other locales the app supports
        ],
        title: Constants.appName,
        theme: isDark ? Constants.darkTheme : Constants.lightTheme,
        home: SplashPage(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
    );
  }
}