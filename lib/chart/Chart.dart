import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../fireStore/FireData.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  ChartData object1 = ChartData();
  ChartData object2 = ChartData();
  ChartData object3 = ChartData();

  bool assume = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<FireData>>(
        stream: readFireData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    "Something went wrong!\n" + snapshot.error.toString()));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            ListView(
              children: (data.map(buildData)).toList(),
            );
            return ListView(
              children: [
                ChartWidget(object1, Colors.blueAccent),
                ChartWidget(object2, Colors.orangeAccent),
                ChartWidget(object3, Colors.purple),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildData(FireData data) {
    if (assume) {
      object1.Domain = data.Domain1;
      object2.Domain = data.Domain2;
      object3.Domain = data.Domain3;
      assume = false;
    }
    searchPosition(object1, data);
    searchPosition(object2, data);
    searchPosition(object3, data);
    return Container();
  }

  searchPosition(ChartData object, FireData data) {
    object.Date.add(data.Date);
    if (object.Domain == (data.Domain1)) {
      object.Position.add(3);
    } else if (object.Domain == (data.Domain2)) {
      object.Position.add(2);
    } else if (object.Domain == (data.Domain3)) {
      object.Position.add(1);
    } else {
      object.Position.add(0);
    }
  }

  ChartWidget(ChartData object, Color color) {
    return Card(
      child: Container(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LineChart(LineChartData(
              minX: 1,
              maxX: 7,
              minY: 0,
              maxY: 3,
              titlesData: FlTitlesData(
                  show: true,
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles:
                          SideTitles(showTitles: true, reservedSize: 40),
                      axisNameWidget: Text(
                        object.Domain.toUpperCase(),
                        style: GoogleFonts.lexend(
                            textStyle: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: color)),
                      ))),
              lineBarsData: [
                LineChartBarData(
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [color, color.withOpacity(0.2)]),
                    belowBarData: BarAreaData(
                        gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [color, color.withOpacity(0.2)]),
                        show: true,
                        color: color.withOpacity(0.25)),
                    spots: [
                      FlSpot(1, object.Position.elementAt(6)),
                      FlSpot(2, object.Position.elementAt(5)),
                      FlSpot(3, object.Position.elementAt(4)),
                      FlSpot(4, object.Position.elementAt(3)),
                      FlSpot(5, object.Position.elementAt(2)),
                      FlSpot(6, object.Position.elementAt(1)),
                      FlSpot(7, object.Position.elementAt(0)),
                    ])
              ])),
        ),
      ),
    );
  }

  Stream<List<FireData>> readFireData() => FirebaseFirestore.instance
      .collection("serpdata")
      .orderBy("Date", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FireData.fromJSON(doc.data())).toList());

  readDomain() async {
    final result = FirebaseFirestore.instance
        .collection("TopWebsite")
        .doc("android games");
    final snapshot = await result.get();
    if (snapshot.exists) {
      var json = snapshot.data();
      return json!['Domain'];
    }
  }
}

class ChartData {
  var Domain = "";
  var Date = [];
  List<double> Position = [];
}
