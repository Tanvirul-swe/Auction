import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  var remaindays;
  int completebidcount = 0;
  int runningbid = 0;
  int totalvalue = 0;
  bool isFinished = false;
 void getdata() async {
    await FirebaseFirestore.instance
        .collection('ProductInformation')
        .doc('product')
        .collection('productlist')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["people"]);
        DateTime Enddate = DateTime.parse(doc['EndDate']);
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        remaindays = date.difference(Enddate).inDays;
        if (remaindays == 0) {
          completebidcount++;
          int temp = int.parse(doc['bid']);
          totalvalue = temp + totalvalue;
        } else {
          runningbid++;
        }
      });
    });
    setState(() {
    isFinished = true;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF000080),
          title: Text('Dashboard'),
        ),
        body: Column(
          children: [
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
                        Text(runningbid.toString()),
                        Text(completebidcount.toString()),
                        Text(totalvalue.toString()),
                      ],
                    ),
                    Divider(color: Colors.black),
                  ],
                ),
              ),
            ),
            isFinished == true
                ? Container(
                    child: SfCircularChart(
                        title: ChartTitle(
                            text:
                                'Prediction of \nRunning Bid,Completed Bid'),
                        legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap),
                        series: <CircularSeries>[
                        // Render pie chart
                        PieSeries<ChartData, String>(
                            dataSource: [
                              ChartData('Running Bid', runningbid.toDouble(), Colors.black),
                              ChartData('Completed Bid', completebidcount.toDouble(), Colors.green),
                              // ChartData('Total value', totalvalue.toDouble(), Colors.purple)
                            ],
                            pointColorMapper: (ChartData data, _) => data.color,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true))
                      ]))
                : Container(),
          ],
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
