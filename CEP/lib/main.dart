import 'package:flutter/material.dart';
import 'Views/home_page.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => ThemeData(
              primarySwatch: Colors.deepPurple,
              buttonColor: Colors.deepPurpleAccent,
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            home: HomePage(),
          );
        });
  }
}

