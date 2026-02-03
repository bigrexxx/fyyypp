import 'package:flutter/material.dart';
import 'package:project/pages/signup.dart';

import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Image.asset(
                'assets/images/welcome.png', // replace with your asset
                height: 220,
              ),

              const SizedBox(height: 32),

              const Text(
                'Hello , Welcome !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Welcome to Peer Tutoring\nCollaborate, Learn and succeed together',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 40),

              // Login Button
              _primaryButton(
                text: 'Login',

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Sign Up Button
              _primaryButton(
                text: 'Sign Up',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF28B66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
