import 'package:auction_app/Services/Database.dart';
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
      this.minBid, this.doc,this.price);

  @override
  _DetailsState createState() => _DetailsState();
}

TextEditingController _controller = TextEditingController();

class _DetailsState extends State<Details> {
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Please enter your Bid price'),
            content: TextField(
              controller: _controller,
              onChanged: (value) async {},
              decoration: InputDecoration(hintText: "price in tk"),
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
                  setState(() async {
                    final ob = DatabaseService(uid: 'some');
                    await ob.updateUserBit(
                        _controller.text.toString(), widget.doc);

                    Navigator.pop(context);
                  });

                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              Expanded(
                child: Container(
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
                      Text('Max price now : ${widget.price} TK'),
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
                      FloatingActionButton.extended(
                        onPressed: () {
                          _displayTextInputDialog(context);
                        },
                        label: Text('Place Bid'),
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
