import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_services.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: GestureDetector(
          onTap: () {
            AuthService().signInWithGoogle();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              'assets/search.png',
            ),
          ),
        ),
      )),
    );
  }
}
