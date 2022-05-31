import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../fireStore/FireData.dart';

class Result extends StatefulWidget {
  const Result({Key? key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FutureBuilder<FireData?>(
            future: readData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                        "Something went wrong!\n" + snapshot.error.toString()));
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                return data == null
                    ? const Center(
                        child: Text("No Search done today!"),
                      )
                    : buildData(data);
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildData(FireData data) {
    // GetCharData domain = GetCharData(data: data);
    return Card(
      child: Container(
        child: ListTile(
          title: Text(
            data.Date,
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(color: Colors.black38)),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(data.Search.toUpperCase(),
                          style: GoogleFonts.lexend(
                              textStyle: TextStyle(
                            fontSize: 17.5,
                            color: Colors.greenAccent.shade700,
                          ))),
                    ),
                    buildRow("1", data.Title1),
                    buildRow("2", data.Title2),
                    buildRow("3", data.Title3),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("DOMAINS",
                          style: GoogleFonts.lexend(
                              textStyle: TextStyle(
                            fontSize: 17.5,
                            color: Colors.greenAccent.shade700,
                          ))),
                    ),
                    buildRow("1", "www." + data.Domain1 + ".com"),
                    buildRow("2", "www." + data.Domain2 + ".com"),
                    buildRow("3", "www." + data.Domain3 + ".com"),
                  ],
                ),
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
        Text(data,
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
            ))),
      ],
    );
  }

  Future<FireData?> readData() async {
    String date = DateTime.now().year.toString() +
        "-" +
        ((int.parse(DateTime.now().month.toString()) < 10)
            ? ("0" + DateTime.now().month.toString())
            : DateTime.now().month.toString()) +
        "-" +
        ((int.parse(DateTime.now().day.toString()) < 10)
            ? ("0" + DateTime.now().day.toString())
            : DateTime.now().day.toString());
    final result = FirebaseFirestore.instance.collection("serpdata").doc(date);
    final snapshot = await result.get();
    if (snapshot.exists) {
      // GetData d = GetData();
      //d.readData();
      return FireData.fromJSON(snapshot.data()!);
    }
  }
}
