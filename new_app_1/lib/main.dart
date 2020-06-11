import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'homeWidget.dart';
import 'app_localizations.dart';

void main() => runApp(MyApp());

List<String> macL = [];
List<String> checkData = [];
List<Map<String, dynamic>> checkListData = [
  {
    "id": "",
    "temp": "",
    "time": "",
  }
];

String currentLang = "";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    checkData.clear();
    return MaterialApp(
      title: 'Tem-Tracker',
      home: Home(),
      // List all of the app's supported locales here
      supportedLocales: [
        Locale('en', 'US'),
        Locale('zh', 'TW'),
      ],
      // These delegates make sure that the localization data for the proper language is loaded
      localizationsDelegates: [
        // THIS CLASS WILL BE ADDED LATER
        // A class which loads the translations from JSON files
        AppLocalizations.delegate,
        // Built-in localization of basic text for Material widgets
        GlobalMaterialLocalizations.delegate,
        // Built-in localization for text direction LTR/RTL
        GlobalWidgetsLocalizations.delegate,
      ],
      // Returns a locale which will be used by the app
      localeResolutionCallback: (locale, supportedLocales) {
        // Check if the current device locale is supported
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            currentLang = locale.languageCode;
            return supportedLocale;
          }
        }
        // If the locale of the device is not supported, use the first one
        // from the list (English, in this case).
        currentLang = "en";
        return supportedLocales.first;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tem-Tracker'),
      ),
      body: Center(
        child: Column(),
      ),
    );
  }
}
