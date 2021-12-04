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
  final List<ChartData> chartData = [
    ChartData('Total Value', 25,Colors.redAccent),
    ChartData('Completed Bid', 70,Colors.black),
    ChartData('Running Bid', 34,Colors.green),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
        backgroundColor: Color(0xFF000080),
        title: Text('Dashbord'),
      ),

      body: Center(
          child: Container(
              child: SfCircularChart(
                title: ChartTitle(text: 'Prediction of Total value\nRunning Bid,Completed Bid'),
                  legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap),
                  series: <CircularSeries>[
                    // Render pie chart
                    PieSeries<ChartData, String>(
                        dataSource: chartData,
                        pointColorMapper:(ChartData data,  _) => data.color,
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y,
                      dataLabelSettings: DataLabelSettings(isVisible: true)
                    )
                  ]
              )
          )
      ),

      // body: Center(
      //   child: StreamBuilder<QuerySnapshot>(
      //       stream: _usersStream,
      //       builder:
      //           (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasError) {
      //           return Text('Something went wrong');
      //         }
      //
      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return CircularProgressIndicator();
      //         }
      //         return
      //           Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Container(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       Text('Running bid'),
      //                       Text('Completed bid'),
      //                       Text('Total value'),
      //
      //                     ],
      //                   ),
      //                   SizedBox(
      //                     height: 10,
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //                       Text('10'),
      //                       Text('10'),
      //                       Text('10'),
      //                     ],
      //
      //                   ),
      //                   Divider(
      //                       color: Colors.black
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //       }),
      // ),
    );
  }

}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

