import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'SignIn_and_SignUp/SignIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignIn(),
      // home: LoginRegistration(),
    );
  }
}