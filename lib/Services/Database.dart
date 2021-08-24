import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  User? user = FirebaseAuth.instance.currentUser;

  final CollectionReference collectionReference = FirebaseFirestore.instance.collection('ProductInformation');

  Future updateUserData(String name,String discription,String minbit,String date,String url)async{

    return await collectionReference.doc(uid).set({
      'product':name,
      'Description':discription,
      'MinimumBit':minbit,
      'EndDate':date,
      'photo':url,
    });

  }

  Stream<QuerySnapshot> get product_info{
    return collectionReference.snapshots();
  }

}