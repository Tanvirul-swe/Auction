import 'package:auction_app/AuctionGallery/AddItem.dart';
import 'package:auction_app/Dashbord/dashbord.dart';
import 'package:auction_app/ProductDetails/product_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuctionItemList extends StatefulWidget {
  const AuctionItemList({Key? key}) : super(key: key);
  static String id = 'AuctionItemList';

  @override
  _AuctionItemListState createState() => _AuctionItemListState();
}

class _AuctionItemListState extends State<AuctionItemList> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('ProductInformation')
      .doc('product')
      .collection('productlist')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction list'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 0) {
          } else {
            Navigator.pushNamed(context, Dashboard.id);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_people),
            label: 'My post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Dashboard',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddItem.id);
        },
        child: Icon(Icons.add),
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
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Color(0xFFCF7BD2),
                                Colors.blue.shade100,
                              ],
                              begin: const FractionalOffset(0.0, 1.0),
                              end: const FractionalOffset(1.0, 2.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          boxShadow: [
                            BoxShadow(
                                //grey colored shadow
                                color: Colors.grey,
                                //Applying softening effect
                                blurRadius: 3.0,
                                //move 1.0 to right (horizontal), and 3.0 to down (vertical)
                                offset: Offset(1.0, 3.0)),
                          ],
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.height / 7,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.green,
                                  image: DecorationImage(
                                    image: NetworkImage(data['photo']),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name : ${data['product']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text('Minimum Bid: ${data['MinimumBit']}'),
                                  Text('End Date: ${data['EndDate']}'),
                                ],
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      // var doc_ref = await FirebaseFirestore.instance.collection("ProductInformation").get();
                      // doc_ref.docs.forEach((result) {
                      //   print(result.data());
                      // });
                      print(document.id);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Details(
                              data['product'],
                              data['Description'],
                              data['EndDate'],
                              data['photo'],
                              data['MinimumBit'],
                              document.id.toString(),
                              data['bid'].toString())));
                    },
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}
