import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/home_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/question_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  return runApp((
    MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ThemeNotifier()),
    ChangeNotifierProvider(create: (_) => QuestionProvider()),
    ChangeNotifierProvider(create: (_) => BookmarkProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
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
        initialRoute: '/login',
        routes: {
          '/': (context) => const Home(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/questions': (context) => QuestionScreen(),
          '/bookmarks': (context) => BookmarkScreen(),
        },
      ),
    );
  }
}

