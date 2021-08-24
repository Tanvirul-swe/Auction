
import 'dart:io';

import 'package:auction_app/Constants/TextField_design.dart';
import 'package:auction_app/Services/Database.dart';
import 'package:auction_app/Services/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class AddItem extends StatefulWidget {
  static String id = 'AddItem';
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  UploadTask? task;
  File? file;
  bool pathcheck = false;
  TextEditingController ProductNameController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController BidController = TextEditingController();
  DateTime? date;
  Future pickDate() async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }

  String getDate() {
    if (date == null) {
      return 'Select Bid end date';
    } else {
      return '${date!.day}/${date!.month}/${date!.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          uploadFile();
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
              0.1,
              0.9
            ], colors: [
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.1)
            ])),
        child: Column(
          children: [
            TextField(
              controller: ProductNameController,
              cursorColor: Colors.orange,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: KTextFieldDecoration.copyWith(
                  labelText: 'Product name',
                  prefixIcon: Icon(Icons.drive_file_rename_outline)),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: DescriptionController,
              cursorColor: Colors.orange,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: KTextFieldDecoration.copyWith(
                  labelText: 'Description', prefixIcon: Icon(Icons.details)),
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: BidController,
              cursorColor: Colors.orange,
              style: TextStyle(
                color: Colors.black,
              ),
              decoration: KTextFieldDecoration.copyWith(
                  labelText: 'Minimum Bit', prefixIcon: Icon(Icons.money)),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                pickDate();
              },
              child: Text(getDate()),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200,
              width: 200,
              child: Center(

                child:InkWell(
                  onTap: (){
                    selectFile();
                  },
                  child: pathcheck==false?Text('Select image'): Image.file(file!),
                  ),
                )
              ),
          ],
        ),
      ),
    );
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() {
      pathcheck = true;
      file = File(path);
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
     return  await DatabaseService(uid: 'key11').updateUserData(
         ProductNameController.text.toString(),
         DescriptionController.text.toString(),
         BidController.text.toString(),
         getDate().toString(),urlDownload.toString());


  }
}
