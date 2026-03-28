import 'package:flutter/material.dart';
import 'package:projects/viewmodels/child_menu_viewmodel.dart';
import 'package:projects/viewmodels/home_viewmodel.dart';
import 'package:projects/viewmodels/settings_viewmodel.dart';
import 'package:projects/views/screens/graphmotor_screen.dart';
import 'package:projects/views/screens/home_screen.dart';
import 'package:projects/views/screens/stereotypical_screen.dart';
import 'package:provider/provider.dart';
import 'package:projects/views/screens/childdata_screen.dart';
import 'package:projects/views/screens/childnumber_screen.dart';
import 'package:projects/views/screens/createaccount_screen.dart';
import 'package:projects/views/screens/login_screen.dart';
import 'package:projects/views/screens/opt_screen.dart';
import 'package:projects/views/screens/splash_screen.dart';
import 'package:projects/views/screens/terms_screen.dart';
import 'package:projects/views/screens/whatareyou_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ChildMenuViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // 🔥 KEEP YOUR TESTING SCREENS HERE
        //home: SplashScreen(),
        //home: LoginScreen(),
        //home: TermsScreen(),
        //home: WhatAreYouScreen(),
        //home: CreateAccountScreen(),
        //home: OtpScreen(phoneNumber: '+201001234567'),
        //home: ChildNumberScreen(),
        //home: ChildDataScreen(),

        // ✅ Default screen
        //home: const HomeScreen(),
        //home: GraphmotorScreen(),
        home: StereotypicalScreen(),

        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F7FA),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
      ),
    );
  }
}


/*class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const (),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = "0";
  String _input = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _input = "";
        _output = "0";
      } else if (buttonText == "=") {
        _output = _calculate(_input).toString();
        _input = ""; // Clear input after calculation
      } else {
        _input += buttonText;
        _output = _input;
      }
    });
  }

  double _calculate(String input) {
    // Simple calculation logic for +, -, *, /
    List<String> tokens = _tokenize(input);
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double nextNumber = double.parse(tokens[i + 1]);

      switch (operator) {
        case "+":
          result += nextNumber;
          break;
        case "-":
          result -= nextNumber;
          break;
        case "x":
          result *= nextNumber;
          break;
        case "/":
          if (nextNumber != 0) {
            result /= nextNumber;
          } else {
            // Handle division by zero
            return 0;
          }
          break;
      }
    }
    return result;
  }

  List<String> _tokenize(String input) {
    // Split input into tokens for calculation
    List<String> tokens = [];
    String number = "";

    for (int i = 0; i < input.length; i++) {
      String char = input[i];

      if (double.tryParse(char) != null) {
        // If character is a digit, add to number
        number += char;
      } else {
        // If character is an operator, push number and operator to tokens
        if (number.isNotEmpty) {
          tokens.add(number);
          number = "";
        }
        tokens.add(char);
      }
    }
    if (number.isNotEmpty) {
      tokens.add(number); // Add last number if exists
    }

    return tokens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                _output,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("7"),
                _buildButton("8"),
                _buildButton("9"),
                _buildButton("/"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("4"),
                _buildButton("5"),
                _buildButton("6"),
                _buildButton("x"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("1"),
                _buildButton("2"),
                _buildButton("3"),
                _buildButton("-"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton("C"),
                _buildButton("0"),
                _buildButton("="),
                _buildButton("+"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    return ElevatedButton(
      onPressed: () => _buttonPressed(buttonText),
      child: Text(buttonText, style: const TextStyle(fontSize: 24)),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(70, 70),
      ),
    );
  }
}
*/