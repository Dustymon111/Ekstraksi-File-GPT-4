import 'package:aplikasi_ekstraksi_file_gpt4/providers/bookmark_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/global_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/question_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/subject_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/user_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/providers/theme_provider.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/bookmark_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/create_subject.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/home_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/login_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/register_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/splash_screen.dart';
import 'package:aplikasi_ekstraksi_file_gpt4/screen/test_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: ".env");
  // OpenAI.apiKey = dotenv.env["OPENAI_API_KEY"]!;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  return runApp((MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => QuestionProvider()),
      ChangeNotifierProvider(create: (_) => BookmarkProvider()),
      ChangeNotifierProvider(create: (_) => SubjectProvider()),
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
        debugShowCheckedModeBanner: false,
        title: 'Ekstraksi File',
        theme: ThemeData(
          shadowColor: Color(0xFF1C88BF),
          splashColor: Colors.black.withOpacity(0.3),
          primaryColor: Colors.white,
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1C88BF),
            surface: Colors.white,
            onPrimary: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1C88BF),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF1C88BF),
            unselectedItemColor: Color(0xFF121212),
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Color(0xFF1C88BF)),
            bodyLarge: TextStyle(color: Color(0xFF121212)),
            bodyMedium: TextStyle(color: Color(0xFF121212)),
            displayLarge: TextStyle(color: Color(0xFF121212)),
          ),
        ),
        darkTheme: ThemeData(
          splashColor: Colors.white.withOpacity(0.5),
          shadowColor: Color(0xFF1C88BF),
          primaryColor: const Color(0xFF121212),
          colorScheme: const ColorScheme.dark(
            primary: Colors.white,
            surface: Colors.black,
            onPrimary: Color(0xFF121212),
          ),
          cardColor: const Color(0xFF1C88BF),
          scaffoldBackgroundColor: Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121212),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          // elevatedButtonTheme: ElevatedButtonThemeData(
          //     style: ElevatedButton.styleFrom(
          //   backgroundColor: Color(0xFF1C88BF),
          // )),

          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF1C1C1C),
            selectedItemColor: Color(0xFF1C88BF),
            unselectedItemColor: Colors.white,
          ),
          textTheme: const TextTheme(
            bodySmall: TextStyle(color: Color(0xFF1C88BF)),
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            displayLarge: TextStyle(color: Colors.white),
          ),
        ),
        themeMode: theme.currentTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => Home(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/add-bookmark': (context) => CreateSubject(),
          '/bookmarks': (context) => BookmarkScreen(),
          '/test': (context) => TestScreen(),
        },
      ),
    );
  }
}
