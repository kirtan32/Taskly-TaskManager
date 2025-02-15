import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager/presentation/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 3), () {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(width: 128, height: 128, 'assets/logo_transparent.png'),
            SizedBox(height: 24),
            Text(
              "Task Manager",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
