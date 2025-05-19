import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter_firebase/widgets/custom_text_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to Home Page!', 
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            )),
        ),
    );
  }
}