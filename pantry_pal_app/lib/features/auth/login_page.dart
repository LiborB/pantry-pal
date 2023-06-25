import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

import '../../store/app_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var emailError = "";

  void onLoginClick() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email" ||
          e.code == "user-not-found" ||
          e.code == "wrong-password") {
        setState(() {
          emailError = "Username/password incorrect";
        });
      }
    } catch (e) {
      showDialog(context: context, builder: ((context) => Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Login")),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SignInButton(
                  Buttons.Google,
                  text: "Sign in with Google",
                  onPressed: () async {
                    await Provider.of<AppStore>(context, listen: false)
                        .handleSignInGoogle();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
