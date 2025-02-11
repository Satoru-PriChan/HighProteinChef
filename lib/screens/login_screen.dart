import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart' as Auth;
import 'package:high_protein_chef/routers/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  User? previousUser; 
  bool _showPassword = false;

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
      appBar: AppBar(title: const Text("Login"),),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: _emailFormKey,
              child: TextFormField( 
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    _isEmailValid = _emailFormKey.currentState?.validate() ?? _isEmailValid;
                  });
                },
                validator: (value) {
                  if (authProvider.isValidEmail(value ?? "")) {
                    return null;
                  } else {
                    return "This is not a valid email";
                  }
                }, 
                decoration: const InputDecoration(
                  labelText: "email",
                  ),
                ),
            ),
            Form(
              key: _passwordFormKey,
              child: TextFormField(
                controller: passwordController,
                obscureText: !_showPassword,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) {
                  setState(() {
                    _isPasswordValid = _passwordFormKey.currentState?.validate() ?? _isPasswordValid;  
                  });
                },
                validator: (value) {
                  if (authProvider.isValidPassword(value ?? "")) {
                    return null;
                  } else {
                    return "Uppercase, Lowercase, Numeric, Special character";
                  }
                },
                decoration: InputDecoration(
                  labelText: "Password", 
                  suffixIcon: IconButton(
                    icon: _showPassword ?
                      const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                      onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword; 
                      });
                      },
                  )
                ),
              ),
            ),
            const SizedBox(height: 16),

            authProvider.isLoading 
              ? const CircularProgressIndicator()
              : _isEmailValid && _isPasswordValid ? 
                ElevatedButton(
                  onPressed: () {
                    authProvider.login(emailController.text, passwordController.text);
                  }, 
                  child: const Text("Login"),
                )
               : 
                const Text("Login", style: TextStyle(color: Colors.grey),),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context, 
                    "/register"
                  );
                }, 
                child: const Text("Register")
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