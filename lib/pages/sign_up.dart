import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter_firebase/widgets/custom_text_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(183, 28, 11, 51),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopImage(height),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(),
                    _gap(),
                    _buildEmailField(),
                    _gap(),
                    _buildPasswordField(),
                    _gap(height: 120),
                    _buildSignUpButton(context),
                    _gap(),
                    CustomTextButton(
                      onPressed: () => Navigator.pushNamed(context, "/sign-in"), 
                      buttonText: "Zaten Hesabım Var",
                      textColor: const Color.fromARGB(255, 255, 255, 255),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopImage(double height) {
    return Container(
      height: height * 0.25,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/top_img.png"),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      "Merhaba, \nHadi Kayıt Olalım",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir e-mail girin';
        }
        if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
          return 'Geçersiz e-mail formatı';
        }
        return null;
      },
      onSaved: (value) => _email = value!.trim(),
      decoration: _inputDecoration("E-Posta"),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Lütfen bir şifre girin';
        }
        if (value.length < 6) {
          return 'Şifre en az 6 karakter olmalıdır';
        }
        return null;
      },
      onSaved: (value) => _password = value!,
      obscureText: true,
      decoration: _inputDecoration("Şifre"),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: signUp,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(115, 255, 255, 255),
          ),
          child: const Center(
            child: Text(
              "Hesap Oluştur",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap({double height = 20}) => SizedBox(height: height);

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }
  // Move signUp inside the state class to access instance variables and context
  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Firebase Authentication ile kayıt işlemi
      try {
        var userResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print(userResult.user!.email);
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('Kayıt başarılı'))),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, "/home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt başarısız: ${e.toString()}')),
        );
      }
    }
  }
}