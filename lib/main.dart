import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

Map responseMessageIN = {};
Map responseMessageAU = {};
Map responseMessageUS = {};
Map responseMessageUK = {};
Map responseMessageJP = {};

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();
  Future apiCall(searchString, String country, int index) async {
    try {
      http.Response response;
      response = await http.get(Uri.parse("https://serpapi.com/search.json?q=" +
          searchString +
          "&google_domain=google.com&gl=" +
          country +
          "&hl=en&api_key=66adceb66d98ef0c70f4c8fb24cc9a5e6bac675ac63b9a650cfbab29fb362e10"));
      if (response.statusCode == 200) {
        setState(() {
          switch (country) {
            case "in":
              responseMessageIN = json.decode(response.body);
              break;
            case "au":
              responseMessageAU = json.decode(response.body);
              break;
            case "us":
              responseMessageUS = json.decode(response.body);
              break;
            case "uk":
              responseMessageUK = json.decode(response.body);
              break;
            case "jp":
              responseMessageJP = json.decode(response.body);
              break;
          }
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: Text(
          "SERP API",
          style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                    controller: textEditingController,
                    onSubmitted: (value) {
                      String searchValue = value;
                      searchValue = searchValue.replaceAll(" ", "+");
                      apiCall(searchValue, "in", 0);
                      apiCall(searchValue, "au", 1);
                      apiCall(searchValue, "us", 2);
                      apiCall(searchValue, "uk", 3);
                      apiCall(searchValue, "jp", 4);
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(left: 75),
                        suffixIcon: Icon(Icons.search_outlined),
                        hintText: " Enter your search ...")),
              ),
            ),
            Container(
              child: Column(
                children: [
                  if (!responseMessageIN.isEmpty) resultContainer("India", 0),
                  if (!responseMessageAU.isEmpty)
                    resultContainer("Australia", 1),
                  if (!responseMessageUS.isEmpty) resultContainer("US", 2),
                  if (!responseMessageUK.isEmpty) resultContainer("UK", 3),
                  if (!responseMessageJP.isEmpty) resultContainer("Japan", 4),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Container resultContainer(String country, int index) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                  height: 45,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Text(
                    country,
                    style: const TextStyle(
                        fontSize: 20,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w900),
                  )),
              containerContent(index, 0),
              containerContent(index, 1),
              containerContent(index, 2),
            ],
          ),
        ),
      ),
    );
  }

  Container containerContent(int index, int i) {
    Map responseMessage = {};
    switch (index + 1) {
      case 1:
        responseMessage = responseMessageIN;
        break;
      case 2:
        responseMessage = responseMessageAU;
        break;
      case 3:
        responseMessage = responseMessageUS;
        break;
      case 4:
        responseMessage = responseMessageUK;
        break;
      case 5:
        responseMessage = responseMessageJP;
        break;
    }
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Row(
        children: [
          const SizedBox(
            width: 30,
          ),
          Text(
            (responseMessage['organic_results'] != null)
                ? responseMessage['organic_results'][i]['position'].toString()
                : "",
            style: GoogleFonts.lexend(),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final url = (responseMessage['organic_results'] != null)
                    ? responseMessage['organic_results'][i]['displayed_link']
                        .toString()
                    : "";
                if (await canLaunch(url)) {
                  launch(url);
                }
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  (responseMessage['organic_results'] != null)
                      ? responseMessage['organic_results'][i]['title']
                      : "",
                  style: GoogleFonts.lexend(
                      decoration: TextDecoration.underline, color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
