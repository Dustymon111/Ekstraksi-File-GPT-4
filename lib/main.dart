import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/home_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/register_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/splash_screen.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // OpenAI.apiKey = dotenv.env["OPENAI_API_KEY"]!;
  return runApp((MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => QuestionProvider()),
      ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => GlobalProvider()),
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
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => Home(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/bookmarks': (context) => BookmarkScreen(),
        },
      ),
    );
  }
}
