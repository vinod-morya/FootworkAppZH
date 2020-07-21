import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:footwork_chinese/ui/dashboard/MasterDashBoard.dart';
import 'package:footwork_chinese/ui/forgetPass/ForgotPassword.dart';
import 'package:footwork_chinese/ui/login/login_screen.dart';
import 'package:footwork_chinese/ui/register/RegistrationScreen.dart';
import 'package:footwork_chinese/ui/splash/SplashScreen.dart';
import 'package:footwork_chinese/utils/FallbackCupertinoLocalisationsDelegate.dart';
import 'package:footwork_chinese/utils/app_localizations.dart';

import 'network/ApiConfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiConfiguration.initialize(ConfigConfig('', false));
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '篮球脚步训练',
      debugShowCheckedModeBanner: false,
      // List all the app's supported locales here
      supportedLocales: [
        // English
        // const Locale('en'),
        // Generic Chinese
        const Locale('zh', 'CN'),
      ],

      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // A class, which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],

      // Returns a locale, which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        if (locale == null) {
          return supportedLocales.first;
        }
        return supportedLocales.first;
      },

      theme: ThemeData(
        primarySwatch: MaterialColor(
          0xFFD50A30,
          const <int, Color>{
            50: const Color(0xFFD50A30),
            100: const Color(0xFFD50A30),
            200: const Color(0xFFD50A30),
            300: const Color(0xFFD50A30),
            400: const Color(0xFFD50A30),
            500: const Color(0xFFD50A30),
            600: const Color(0xFFD50A30),
            700: const Color(0xFFD50A30),
            800: const Color(0xFFD50A30),
            900: const Color(0xFFD50A30),
          },
        ),
      ),
      // Application's top-level routing table.
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/forgotPass': (BuildContext context) => ForgotPassScreen(),
        '/registrationScreen': (BuildContext context) => RegistrationScreen(),
        '/dashboardScreen': (BuildContext context) => MasterDashboard(),
      },

      home: SplashScreen(),
    );
  }
}
