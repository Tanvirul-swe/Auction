import 'package:auction_app/AuctionGallery/list_of_items.dart';
import 'package:auction_app/Constants/TextField_design.dart';
import 'package:auction_app/Services/Database.dart';
import 'package:auction_app/SignIn_and_SignUp/Registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatefulWidget {
  static  String id = 'SignIn';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // final signIn = Authentication();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordValidation = false;
  bool emailValidation = false;
  bool emailEmptyValidation = false;
  bool passwordEmptyValidation = false;
  bool emailVerify = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter your gmail'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(hintText: "Registered gmail"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    codeDialog = email;
                    sendPasswordResetEmail(email!);
                    Navigator.pop(context);
                    print(email);
                  });
                },
              ),
            ],
          );
        });
  }

  //Reset user password send reset link in user register email
  Future sendPasswordResetEmail(String email) async {
    // Toast.show("Check email", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  String? codeDialog;
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text('Login',
      //   ),
      // ),

      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  // color: Colors.purpleAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Asset/auctionimage.jpg',
                        height: 250,
                        width: 250,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Color(0xFFDFE1F3),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent,
                          offset: const Offset(3.0, 3.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Here User email Input field design.
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        cursorColor: Colors.orange,
                        controller: emailController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                            errorText: emailValidation
                                ? 'Email not registered'
                                : emailEmptyValidation
                                    ? 'Empty email'
                                    : emailVerify
                                        ? 'Email not verify check email'
                                        : null,
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined)),
                      ),

                      //User password field design

                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        cursorColor: Colors.orange,
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                            labelText: 'Password',
                            errorText: passwordValidation
                                ? 'wrong password'
                                : passwordEmptyValidation
                                    ? 'Empty password'
                                    : null,
                            prefixIcon: Icon(Icons.password_rounded)),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            elevation: 10.0,
                            onPressed: () async {
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: emailController.text.toString(),
                                  password: passwordController.text.toString(),
                                );
                                User? user = FirebaseAuth.instance.currentUser;

                                if (user != null && user.emailVerified) {
                                  emailVerify = false;
                                  // await DatabaseService(uid: 'key').updateUserData('tab', 'thi is iphone 11', 10);

                                  Navigator.pushNamed(context, AuctionItemList.id);
                                } else if (user != null &&
                                    !user.emailVerified) {
                                  setState(() {
                                    emailVerify = true;
                                  });
                                }
                              } on FirebaseAuthException catch (e) {
                                setState(() {
                                  emailController.text.isEmpty
                                      ? emailEmptyValidation = true
                                      : emailEmptyValidation = false;
                                  passwordController.text.isEmpty
                                      ? passwordEmptyValidation = true
                                      : passwordEmptyValidation = false;
                                  e.code == 'user-not-found'
                                      ? emailValidation = true
                                      : emailValidation = false;
                                  e.code == 'wrong-password'
                                      ? passwordValidation = true
                                      : passwordValidation = false;
                                });
                              }
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.lato(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                            child: Text(
                              'Forgot password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.redAccent,
                              ),
                            ),
                            onTap: () {
                              _displayTextInputDialog(context);
                              // Do something when click forgot button.
                            },
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: Colors.grey,
                            textColor: Colors.white,
                            elevation: 10.0,
                            onPressed: () {
                              Navigator.pushNamed(context, Registration.id);
                              setState(() {});
                            },
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.lato(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
