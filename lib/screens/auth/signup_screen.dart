import 'package:drape_shoppe_crm/controllers/supabaseController.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign up',
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sign Up to create your account',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            TextField(
              focusNode: nameFocusNode,
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'User Name',
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: UnderlineInputBorder(),
              ),
            ),
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
                onPressed: () => SupabaseController.instance.signUp(
                  context,
                  nameController.text,
                    emailController.text,
                    passwordController.text
                    ),
                child: const Text('Sign Up'),),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  context.goNamed('login');
                },
                child: const Text('Already have an account? Login'),)
          ],
        ),
      ),
    );
  }
}
