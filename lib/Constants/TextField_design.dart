
import 'package:flutter/material.dart';

const KTextFieldDecoration =InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.all(8.0),
  labelText: '',
  // prefixIcon: Icon(Icons.people_alt_outlined),
  labelStyle: TextStyle(),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(25.0)),

  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white,width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
  ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Colors.white, width: 1.5),
  //   borderRadius: BorderRadius.circular(20.0),
  // ),
);