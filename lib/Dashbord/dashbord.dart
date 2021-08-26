import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  static String id = 'Dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
    .collection('ProductInformation')
    .doc('product')
    .collection('productlist')
    .snapshots();


class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashbord'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Running bid'),
                            Text('Completed bid'),
                            Text('Total value'),

                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('10'),
                            Text('10'),
                            Text('10'),
                          ],

                        ),
                        Divider(
                            color: Colors.black
                        ),
                      ],
                    ),
                  ),
                );
            }),
      ),
    );
  }
}



