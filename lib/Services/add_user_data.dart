import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserData {
  final String uid;
  AddUserData({required this.uid});

  CollectionReference _users = FirebaseFirestore.instance.collection('user');
  Future Adduserinfo(
    String name,
    String email,
    String phone,
    String password,
    String present_address,
  ) async {
    return _users
        .doc(uid)
        .set({
          'name': name, // John Doe
          'email': email, // Stokes and Sons
          'phone': phone, // 42
          'password': password,
          'present_address': present_address,
          'url': 'https://i.ibb.co/M6hhCmN/profile.jpg',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future UpdateProfile(String url) async {
    return _users.doc(uid).update({
      'url':url,
    });
  }

  Stream<QuerySnapshot> get brews {
    return _users.snapshots();
  }
}
