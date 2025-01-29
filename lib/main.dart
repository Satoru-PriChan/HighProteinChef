import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:high_protein_chef/providers/recipe_provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart' as Auth;
import 'package:high_protein_chef/screens/favorites_screen.dart';
import 'package:high_protein_chef/screens/home_screen.dart';
import 'package:high_protein_chef/screens/login_screen.dart';
import 'package:high_protein_chef/screens/recipe_detail_screen.dart';
import 'package:high_protein_chef/screens/register_screen.dart';
import 'package:high_protein_chef/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //debug
  const apiKey = String.fromEnvironment('apiKey');
  print(apiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => Auth.AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => HomeScreen(),
          '/login': (context) => LoginScreen(),
          '/favorites': (context) => FavoritesScreen(),
          '/register': (context) => RegisterScreen(),
          '/recipe_detail': (context) => RecipeDetailScreen(),
          '/profile': (context) => ProfileScreen(),
        },
      ),
    );
  }
}