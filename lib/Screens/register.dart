import 'package:chatapp/Auth/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/button.dart';
import '../Widgets/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cnfPasswordcontroller = TextEditingController();

  void signUP() async {
    if (passwordController.text != cnfPasswordcontroller.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password Do Not Match')));
      return;
    } else {
      final authService = Provider.of<AuthService>(context, listen: false);
      try {
        authService.registerWithEmailAndPassword(
            emailController.text, passwordController.text);
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const SizedBox(height: 100),
            const Icon(Icons.lock, size: 120),
            const SizedBox(height: 50),
            const Text('Register',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: MyTextField(
                  controller: emailController,
                  hintText: 'E-mail',
                  ObscureText: false),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  ObscureText: true),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: MyTextField(
                  controller: cnfPasswordcontroller,
                  hintText: 'Confirm Password',
                  ObscureText: true),
            ),
            const SizedBox(height: 30),
            MyButton(onTap: signUP, text: 'Register'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: widget.onTap,
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
