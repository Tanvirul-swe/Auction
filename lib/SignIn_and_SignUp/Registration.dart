import 'package:auction_app/Constants/TextField_design.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registration extends StatefulWidget {
  static String id = 'Registration';
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  // final signIn = Authentication();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController NameController = TextEditingController();
  bool passwordValidation = false;
  bool emailValidation = false;
  bool emailEmptyValidation = false;
  bool passwordEmptyValidation = false;
  bool nameEmptyValidation = false;
  bool email_validation = false;
  bool name_validation = false;
  bool useEmail = false;
  bool emailVerify = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // //Reset user password send reset link in user register email
  // Future sendPasswordResetEmail(String email) async {
  //   // Toast.show("Check email", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
  //   return _firebaseAuth.sendPasswordResetEmail(email: email);
  // }

  String? codeDialog;
  String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: Colors.red,
            iconSize: 30.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                      Text(
                        'Sign UP',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        cursorColor: Colors.orange,
                        controller: NameController,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        decoration: KTextFieldDecoration.copyWith(
                            errorText:
                                nameEmptyValidation ? 'Empty name' : null,
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.person)),
                      ),
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
                            labelText: 'Email',
                            errorText:
                                emailEmptyValidation ? 'Empty gmail':useEmail?'Email already registered':null,
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
                              String email = emailController.text.toString();
                              String password = passwordController.text.toString();
                              String name = NameController.text.toString();
                              try {
                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                  email: email,
                                  password: password,
                                );

                                if(UserCredential!=null){
                                  User? user = FirebaseAuth.instance.currentUser;
                                  if (user!= null && !user.emailVerified) {
                                    await user.sendEmailVerification();
                                  }
                                  Navigator.pop(context);
                                }
                                //
                                // if (user != null && user.emailVerified) {
                                //   emailVerify = false;
                                // } else if (user != null &&
                                //     !user.emailVerified) {
                                //   await user.sendEmailVerification();
                                //   setState(() {
                                //     emailVerify = true;
                                //   });
                                // }
                              } on FirebaseAuthException catch (e) {

                                setState(() {
                                  if(e.code=='email-already-in-use'){
                                    useEmail = true;
                                  }

                                  emailController.text.isEmpty
                                      ? emailEmptyValidation = true
                                      : emailEmptyValidation = false;
                                  NameController.text.isEmpty
                                      ? nameEmptyValidation = true
                                      : nameEmptyValidation = false;
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
                              'Sign Up',
                              style: GoogleFonts.lato(),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
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
