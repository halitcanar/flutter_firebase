import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter_firebase/widgets/custom_text_button.dart';
import '../services/auth_service.dart';
import 'package:learn_flutter_firebase/utils/page_transitions.dart';
import 'package:learn_flutter_firebase/pages/sign_up.dart';
import 'package:learn_flutter_firebase/pages/home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(183, 28, 11, 51),
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
                    _gap(height: 60),
                    _buildSignInButton(),
                    _gap(),
                    _buildAccountOptions(),
                    _gap(),
                    _buildGuestLoginButton(),
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
      "Merhaba, \nHadi Giriş Yapalım",
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
      validator: _validateEmail,
      onSaved: (value) => _email = value!.trim(),
      decoration: _inputDecoration("E-Posta"),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen bir e-mail girin';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      return 'Geçersiz e-mail formatı';
    }
    return null;
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      validator: _validatePassword,
      onSaved: (value) => _password = value!,
      obscureText: true,
      decoration: _inputDecoration("Şifre"),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Lütfen bir şifre girin';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalıdır';
    }
    return null;
  }

  Widget _buildSignInButton() {
    return Center(
      child: TextButton(
        onPressed: _signIn,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 90),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(115, 255, 255, 255),
          ),
          child: const Center(
            child: Text(
              "Giriş Yap",
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

  Widget _buildAccountOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextButton(
          onPressed: () {}, 
          buttonText: "Şifremi Unuttum",
          textColor: Colors.white
        ),
        const Text(" / ", style: TextStyle(color: Colors.white)),
        CustomTextButton(
          onPressed: _navigateToSignUp,
          buttonText: "Hesap Oluştur",
          textColor: Colors.white
        ),
      ],
    );
  }

  Widget _buildGuestLoginButton() {
    return CustomTextButton(
      onPressed: _signInAsGuest, 
      buttonText: "Misafir Girişi", 
      textColor: Colors.white
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      SlidePageRoute(
        page: const SignUpPage(),
        direction: AxisDirection.left,
      ),
    );
  }

  Future<void> _signInAsGuest() async {
    final result = await _authService.signInAnonymous();

    if (result is User) {
      Navigator.of(context).push(
        SlidePageRoute(
          page: const HomePage(),
          direction: AxisDirection.up,
        ),
      );
    } else {
      _showErrorMessage('Giriş başarısız: ${result.toString()}');
    }
  }

  Widget _gap({double height = 20}) => SizedBox(height: height);

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    );
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = await _authService.signInWithEmailAndPassword(
        _email,
        _password,
      );
      if (result == "success") {
        _showSuccessMessage("Giriş Başarılı");
        Navigator.of(context).push(
          SlidePageRoute(
            page: const HomePage(),
            direction: AxisDirection.up,
          ),
        );
      } else {
        _showErrorMessage(result);
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Center(child: Text(message))),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
