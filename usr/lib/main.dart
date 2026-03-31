import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const DataAnalysisApp());
}

class DataAnalysisApp extends StatelessWidget {
  const DataAnalysisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qualité de l\'Air - Dakar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00838F), // Un cyan/teal pour un thème environnemental
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
      },
    );
  }
}
