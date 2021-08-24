import 'package:auction_app/AuctionGallery/AddItem.dart';
import 'package:auction_app/AuctionGallery/list_of_items.dart';
import 'package:auction_app/SignIn_and_SignUp/Registration.dart';
import 'package:auction_app/SignIn_and_SignUp/SignIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
        routes: {
          Registration.id: (context) => Registration(),
          AuctionItemList.id:(context)=>AuctionItemList(),
          AddItem.id:(context)=>AddItem(),
        }
        // home: LoginRegistration(),
        );
  }
}
