import 'dart:io';

import 'package:auction_app/Constants/TextField_design.dart';
import 'package:auction_app/Services/Database.dart';
import 'package:auction_app/Services/firebase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // return '0${date!.month}-${date!.day}-${date!.year}';
      return '${date!.year}-0${date!.month}-${date!.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(centerTitle: true,
        backgroundColor: Color(0xFF000080),
        title: Text('Add Item'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF000080),
        onPressed: () async {
          uploadFile();
          Navigator.pop(context);
        },
        child: Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
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
                keyboardType: TextInputType.number,
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
                width: double.infinity,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      selectFile();
                    },
                    child: pathcheck == false
                        ? Image.asset(
                            'Asset/uploadimage.png',
                            width: 100,
                            height: 100,
                          )
                        : Image.file(file!),
                  ),
                ),
              ),
            ],
          ),
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
    return await DatabaseService(
            uid: FirebaseAuth.instance.currentUser!.email.toString())
        .updateUserData(
            ProductNameController.text.toString(),
            DescriptionController.text.toString(),
            BidController.text.toString(),
            getDate().toString(),
            urlDownload.toString());
  }
}
