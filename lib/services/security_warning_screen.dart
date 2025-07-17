import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecurityWarningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 100,
                color: Colors.red[600],
              ),
              SizedBox(height: 30),
              Text(
                'Security Warning',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'This application cannot run on rooted devices or devices with developer mode enabled for security reasons.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Text(
                'Please use this application on a standard device configuration.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[500],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop(); // Close the app
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[600],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: Text(
                  'Exit Application',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}