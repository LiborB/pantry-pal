import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pantry_pal/features/auth/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  var _emailError = "";
  var _passwordError = "";
  var _confirmPasswordError = "";
  var _isLoading = false;

  void onSignupClick() async {
    setState(() {
      _emailError = "";
      _confirmPasswordError = "";
      _isLoading = true;
      _passwordError = "";
    });

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _confirmPasswordError = "Passwords do not match";
      });
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case "invalid-email":
            _emailError = "Email address is invalid";
            break;
          case "email-already-in-use":
            _emailError = "Email address is already in use";
            break;
          case "weak-password":
            _passwordError = e.message ?? "";
        }
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void onLoginClick() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(centerTitle: true, title: const Text("Create Your Account")),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              if (_isLoading) const CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Email",
                    errorText: _emailError.isNotEmpty ? _emailError : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                      errorText:
                          _passwordError.isNotEmpty ? _passwordError : null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Confirm Password",
                      errorText: _confirmPasswordError.isNotEmpty
                          ? _confirmPasswordError
                          : null),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  onPressed: () => onSignupClick(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: TextButton(
                  onPressed: () => onLoginClick(),
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
