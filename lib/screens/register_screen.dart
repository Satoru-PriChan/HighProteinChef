import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_protein_chef/routers/app_router.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart' as Auth;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  User? previousUser; 

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth.AuthProvider>(context, listen: false);
    authProvider.addListener(() {
      if (previousUser != authProvider.user && authProvider.user != null) {
        previousUser = authProvider.user;
        AppRouter.showDialogs(
          context, 
          "User registration completed! ", 
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
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 16,),
              authProvider.isLoading 
              ? CircularProgressIndicator()
              : ElevatedButton(
                onPressed: () {
                  authProvider.register(
                    emailController.text, 
                    passwordController.text
                  );
                }, 
                child: Text("Register")
              )
          ],
        )
        )
    );
  }
}