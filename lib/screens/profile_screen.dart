import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart' as Auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:high_protein_chef/routers/app_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? previousUser; 

    @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth.AuthProvider>(context, listen: false);
    previousUser = authProvider.user;
    authProvider.addListener(() {
      if (previousUser != null && authProvider.user == null && mounted) {
        previousUser = authProvider.user;
        AppRouter.showDialogs(
          context, 
          "User logout completed!", 
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
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: _body(authProvider)
      ),
    );
  }

  Widget _body(Auth.AuthProvider authProvider) {
    if (authProvider.user == null) {
      return Center(child: Text("User not found. Please go back."));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
          const Text("Email:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          Text("${authProvider.user!.email ?? "NO EMAIL"}"),
          SizedBox(height: 20,),
          TextButton(onPressed: () {
            authProvider.logout();
          },
           child: Text("Logout", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)))
        ],
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}