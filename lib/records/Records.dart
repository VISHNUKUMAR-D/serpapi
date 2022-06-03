import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serpapi/fireStore/FireData.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
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
            return ListView(
              children: (data.map(buildData)).toList(),
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
    return Card(
      child: Container(
        height: 150,
        child: ListTile(
          title: Text(
            data.Date,
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(color: Colors.black38)),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(data.Search.toUpperCase(),
                    style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.greenAccent.shade700,
                    ))),
              ),
              buildRow("1", data.Title1),
              buildRow("2", data.Title2),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: buildRow("3", data.Title3),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildRow(String position, String data) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Text(position,
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(
              color: Colors.blue,
            ))),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(data,
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                  fontSize: 12.5,
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                ))),
          ),
        ),
      ],
    );
  }

  Stream<List<FireData>> readFireData() => FirebaseFirestore.instance
      .collection("serpdata")
      .orderBy("Date", descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FireData.fromJSON(doc.data())).toList());
}
