import 'dart:io';

import 'package:auction_app/Services/Database.dart';
import 'package:auction_app/Services/add_user_data.dart';
import 'package:auction_app/Services/firebase_api.dart';
import 'package:auction_app/SignIn_and_SignUp/SignIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

String name='';
String phone='';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static String id = 'profile';
  @override
  _ProfileState createState() => _ProfileState();
}

bool pathcheck = false;

class _ProfileState extends State<Profile> {
  // _makingPhoneCall() async {
  //
  //   if (await canLaunch('tel:$phone')) {
  //     await launch('tel:$phone');
  //   } else {
  //     throw 'Could not launch tel:$phone';
  //   }
  // }
  UploadTask? task;
  File? file;
  bool pathcheck = false;
  CollectionReference users = FirebaseFirestore.instance.collection('user');
  User? user = FirebaseAuth.instance.currentUser;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      pathcheck = true;
      file = File(path);
      uploadFile();
    });
  }

  Future uploadFile() async {
    pathcheck = false;
    if (file == null) return null;
    final fileName = p.basename(file!.path);
    final destination = 'files/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);

    if (task == null) return null;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print(urlDownload.toString());
    return await AddUserData(uid: user!.uid)
        .UpdateProfile(urlDownload.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color(0xFF43CBE5),
        title: Text('Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            final url = data['url'];
            name = data['name'];
            phone = data['phone'];
            return Container(
              height: double.infinity,
              width: double.infinity,
              // padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(30),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    color: Color(0xFF43CBE5),
                    child: Container(
                      child:Stack(
                        children: [
                          Positioned(
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 2.0), //(x,y)
                                    blurRadius: 5.0,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      selectFile();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    color: Colors.red,
                                  )),
                            ),
                            top: 135,
                            right: 70,
                          ),
                        ],
                        overflow: Overflow.visible,
                      ) ,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                         image: DecorationImage(
                          image: NetworkImage("$url"),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 8,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Complete',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                'Running',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '10',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outlined,
                                size: 30,
                                color: Color(0xFF43CBE5),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['name'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.email_outlined,
                                color: Color(0xFF43CBE5),
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['email'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                color: Color(0xFF43CBE5),
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['phone'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: Color(0xFF43CBE5),
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                data['present_address'],
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(
                                        0, 2), // changes position of shadow
                                  ),
                                ]),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SignIn.id);
                                },
                                icon: Icon(Icons.logout)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return Center(
              child: CircularProgressIndicator(
            color: Color(0xFF000080),
          ));
        },
      ),
    );
  }
}
