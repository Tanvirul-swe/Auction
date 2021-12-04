import 'package:auction_app/AuctionGallery/AddItem.dart';
import 'package:auction_app/Services/Database.dart';
import 'package:auction_app/profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  static String id = 'Details';
  final String product_name;
  final String discription;
  final String EndDate;
  final String photoUrl;
  final String minBid;
  final String doc;
  final String price;

  Details(this.product_name, this.discription, this.EndDate, this.photoUrl,
      this.minBid, this.doc, this.price);

  @override
  _DetailsState createState() => _DetailsState();
}

bool valid = false;
TextEditingController _controller = TextEditingController();

int newvalue = 0;
String maxprice='';

class _DetailsState extends State<Details> {
  Future<void> _displayTextInputDialog(BuildContext context) async {
    int present = int.parse(widget.minBid);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter your Bid price'),
            content: TextField(
              controller: _controller,
              onChanged: (value) async {
                newvalue = int.parse(value);
              },
              decoration: InputDecoration(
                  hintText: "price in tk", errorText: 'Minimum Bid $present'),
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
                onPressed: () async {
                  int present = int.parse(widget.minBid);
                  int newvalue = int.parse(_controller.text);
                  int max = int.parse(maxprice.toString());
                   max = max+newvalue;
                  if (present <= newvalue) {
                    setState(() async {
                      final ob = DatabaseService(uid: 'some');
                      await ob.updateUserBit(
                          max.toString(), widget.doc, name, phone);
                      setState(() {});
                      Navigator.pop(context);
                    });
                  } else {}
                },
              ),
            ],
          );
        });
  }

  final CollectionReference _collectionReference = FirebaseFirestore.instance
      .collection('ProductInformation')
      .doc('product')
      .collection('productlist');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000080),
        title: Text('Product Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _collectionReference.doc(widget.doc).get(),
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
            maxprice = data['bid'];
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(widget.photoUrl),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.product_name,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Min Bid\nTK ${widget.minBid}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Text('End of date : ${widget.EndDate}'),
                          Text('Max price now : ${data['bid']} TK'),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'PRODUCT DETAILS',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              letterSpacing: 2.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                widget.discription,
                                style: TextStyle(
                                  fontSize: 15.0,
                                  wordSpacing: 2,
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          data['people'] != "No one bid now"
                              ? Container(
                                  height: 100,
                                  width: double.infinity,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Height Bid person',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data['people']),
                                          Text(data['phone']),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          FloatingActionButton.extended(
                            elevation: 5,
                            backgroundColor: Color(0xFF000080),
                            onPressed: () {
                              _displayTextInputDialog(context);
                            },
                            label: Text('Place Bid'),
                            icon: Icon(Icons.add),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
