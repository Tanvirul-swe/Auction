import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  User? user = FirebaseAuth.instance.currentUser;
  String rng = randomAlphaNumeric(10);

  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('ProductInformation')
      .doc('product')
      .collection('productlist');
  Future updateUserData(String name, String discription, String minbit,
      String date, String url) async {
    return await collectionReference.doc(rng).set({
      'product': name,
      'Description': discription,
      'MinimumBit': minbit,
      'EndDate': date,
      'photo': url,
      'bid': '0',
      'people':'No one bid now',
      'phone':'',
    });
  }
  Future updateUserBit(String bit, String id,String name,String phone) async {
    return await collectionReference.doc(id).update({
      'bid': bit,
      'people':name,
      'phone':phone,
    });

  }

  Stream<QuerySnapshot> get product_info {
    return collectionReference.snapshots();
  }
}
class UploadProfileImage{
  final CollectionReference reference = FirebaseFirestore.instance
      .collection('user');
  User? user = FirebaseAuth.instance.currentUser;



  Future updateUserData(String url) async {
    return await reference.doc(user!.uid).set({
      'photo': url,
    });
  }

}
