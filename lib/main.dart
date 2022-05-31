import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serpapi/records/Records.dart';
import 'package:serpapi/result/Result.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'apiCall/Api.dart';
import 'chart/Chart.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterConfig.loadEnvVariables();

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textEditingController = TextEditingController();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Tabs = [Search(), Result(), Chart(), Records()];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: Text(
          "SERP API",
          style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
        ),
      ),
      body: Tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) => setState(() {
          currentIndex = (value);
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pageview),
            label: "Result",
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Chart",
            backgroundColor: Colors.lightBlueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Records",
            backgroundColor: Colors.lightBlueAccent,
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Search() {
    return Center(
        child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            child: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(left: 75),
                    suffixIcon: Icon(Icons.search_outlined),
                    hintText: " Enter your search ")),
          ),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.greenAccent.shade400,
              child: Container(
                width: 75,
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  "Search",
                  style: GoogleFonts.lexend(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5,
                          color: Colors.white)),
                ),
              ),
              onPressed: () {
                String searchValue = textEditingController.text;
                if ((textEditingController.text.isNotEmpty)) {
                  searchValue = searchValue.replaceAll(" ", "+");
                  Api("in").callAPI(searchValue);
                  setState(() {
                    currentIndex = 1;
                  });
                }
                // australia.callAPI(searchValue);
                // usa.callAPI(searchValue);
                // uk.callAPI(searchValue);
                // japan.callAPI(searchValue);
              })
        ],
      ),
    ));
  }

  resultContainer(String country, Api gl, int index) {
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
              containerContent(gl, 0),
              containerContent(gl, 1),
              containerContent(gl, 2),
            ],
          ),
        ),
      ),
    );
  }

  Container containerContent(Api gl, int i) {
    Map responseMessage = {};

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
