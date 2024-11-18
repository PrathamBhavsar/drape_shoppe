
import 'package:drape_shoppe_crm/controllers/supabaseController.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign in',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            const Text(
              'Enter your credentials to access your account',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            TextField(
              focusNode: emailFocusNode,
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_rounded),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              focusNode: passwordFocusNode,
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Password',
                prefixIcon: Icon(Icons.lock_open_rounded),
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Spacer(),
                Text(
                  'Forgot password?',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () => SupabaseController.instance.login(
                    context, emailController.text, passwordController.text),
                child: const Text('Login')),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  context.goNamed('signup');
                },
                child: const Text('Dont have an account? Sign Up!'))
          ],
        ),
      ),
    );
  }
}
