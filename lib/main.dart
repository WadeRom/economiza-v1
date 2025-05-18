import 'package:economiza/screens/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  const ExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData(
        textTheme: GoogleFonts.figtreeTextTheme(),
        primaryColor: Color(0xFF317E39),
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF317E39)),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF317E39),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF317E39),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF317E39)),
          ),
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
