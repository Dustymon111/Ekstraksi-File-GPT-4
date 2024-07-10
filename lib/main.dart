import 'package:aplikasi_ekstraksi_file_gpt4/screen/home.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp((
    MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => new ThemeNotifier()),
    ],
    child: const MyApp(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => MaterialApp(
        title: 'Ekstraksi File',
        theme: ThemeData(
              primaryColor: Colors.blue,
              colorScheme: ColorScheme.light(
                primary: Colors.indigo,
                onPrimary: Colors.white,
              ),
            ),
            darkTheme: ThemeData(
              primaryColor: Colors.blueGrey,
              colorScheme: ColorScheme.dark(
                primary: Colors.blueGrey,
                onPrimary: Colors.black,
              ),
            ),
        themeMode: theme.currentTheme,
        home: const Home(),
      ),
    );
  }
}

