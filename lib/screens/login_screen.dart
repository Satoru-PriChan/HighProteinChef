import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart' as Auth;
import 'package:high_protein_chef/screens/register_screen.dart';
import 'package:high_protein_chef/routers/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  User? previousUser; 

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth.AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (previousUser != authProvider.user && authProvider.user != null && mounted) {
        previousUser = authProvider.user;
        AppRouter.showDialogs(
          context, 
          "User login completed! Welcome ${authProvider.user!.displayName ?? ""}!", 
          (){
            // on tap OK
            Navigator.popUntil(context, ModalRoute.withName("/home"));
          }, 
          title: "Notice"
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth.AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "email",
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 16),
              authProvider.isLoading 
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () {
                    authProvider.login(emailController.text, passwordController.text);
                  }, 
                  child: Text("Login"),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      "/register"
                    );
                  }, 
                  child: Text("Register")
                )
            
          ],
        )
        ),
    );
  }

  @override 
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}