import 'package:energy_eff/screens/calculator_main.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromRGBO(218, 160, 76, 1),

          // Specify the background color here
        ),
        // Additionally, set the scaffoldBackgroundColor for screens' default background
        scaffoldBackgroundColor: const Color.fromRGBO(32, 33, 44, 1),
        cardColor: const Color.fromRGBO(39, 40, 51, 1),
      ),
      // Set CalculatorMain as the home screen
      home: const CalculatorMain(),
    );
  }
}
