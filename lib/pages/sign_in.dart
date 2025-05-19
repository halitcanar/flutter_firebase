import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter_firebase/widgets/custom_text_button.dart';
import '../services/auth_service.dart';
import 'package:learn_flutter_firebase/utils/page_transitions.dart';
import 'package:learn_flutter_firebase/pages/sign_up.dart'; // Import the SignInPage


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _firebaseAuth = FirebaseAuth.instance;
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
                    _buildSignInButton(context),
                    _gap(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextButton(
                          onPressed: () {}, 
                          buttonText: "Şifremi Unuttum",
                          textColor: const Color.fromARGB(255, 255, 255, 255)
                        ),
                        const Text(
                          " / ",
                          style: TextStyle(color: Colors.white),
                        ),
                        CustomTextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              SlidePageRoute(
                                page: const SignUpPage(), // Use the actual widget instead of a string
                                direction: AxisDirection.left, // Soldan sağa doğru kayma
                              ),
                            );
                      }, 
                          buttonText: "Hesap Oluştur",
                          textColor: const Color.fromARGB(255, 255, 255, 255)
                        ),
                      ],
                    ),
                    _gap(),
                    CustomTextButton(onPressed:() async {
                      final result = await _authService.signInAnonymous();

                      if (result is User) {
                        print(result.uid);
                        Navigator.pushNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Giriş başarısız: ${result.toString()}')),
                        );
                      }
                    }, 
                    buttonText: "Misafir Girişi", 
                    textColor: const Color.fromARGB(255, 255, 255, 255)),
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

  Widget _buildSignInButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: signIn,
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

  Widget _gap({double height = 20}) => SizedBox(height: height);

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 15,
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Firebase Authentication ile giriş işlemi
      try {
        var userResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print(userResult.user!.email);
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Center(child: Text('Giriş başarılı'))),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushNamed(context, "/home");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız: ${e.toString()}')),
        );
      }
    }
  }
}
