import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netflix_clone/screens/splash_screens.dart';
import 'package:netflix_clone/widgets/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Clone',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: MyColor.White, fontSize: 24),
          bodyMedium: TextStyle(color: MyColor.White, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(surface: MyColor.Black),
        useMaterial3: true,
        fontFamily: GoogleFonts.ptSans().fontFamily,
      ),
      home: SplashScreens(),
    );
  }
}
