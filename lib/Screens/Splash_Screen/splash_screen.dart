import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:e_notebook/Screens/Auth/Login/Login_Screen.dart';
import 'package:flutter/material.dart';
import 'package:e_notebook/SharedPreference/SharePref.dart';
import '../Connectivity  Error/connectivity_error_screen.dart';
import '../Dashboard/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) async {
      if (result.contains(ConnectivityResult.mobile) || result.contains(ConnectivityResult.wifi)) {
        // Check if user is logged in
        bool isLoggedIn = await SharedPref.getLoginStatus();

        if (isLoggedIn) {
          // If logged in, go to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  Home()),
          );
        } else {
          // If not logged in, go to Login Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  LoginScreen()),
          );
        }
      } else {
        // If no connectivity, show error screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  ConnectivityErrorScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo1.png'),
      ),
    );
  }
}
