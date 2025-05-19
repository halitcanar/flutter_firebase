import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:learn_flutter_firebase/pages/home_page.dart';
import 'package:learn_flutter_firebase/pages/sign_up.dart';
import 'package:learn_flutter_firebase/pages/sign_in.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug ibaresini kaldırır
      title: 'Flutter Firebase App',
      routes: {
        '/sign-in': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(183, 28, 11, 51),
      ),
      home: Scaffold(
        body: SignInPage(),
      ),
    );
  }
}