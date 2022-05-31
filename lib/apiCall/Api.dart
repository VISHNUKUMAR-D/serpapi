import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

import '../fireStore/FireStore.dart';

class Api {
  late String country;
  Api(String country) {
    this.country = country;
  }
  Future callAPI(searchString) async {
    try {
      http.Response response;
      response = await http.get(Uri.parse(FlutterConfig.get("SERP_URL") +
          "q=" +
          searchString +
          "&" +
          FlutterConfig.get("SERP_DOMAIN") +
          "&gl=" +
          country +
          "&hl=en&api_key=" +
          FlutterConfig.get("SERPAPI_KEY")));
      if (response.statusCode == 200) {
        FireStore fs = FireStore(
            mapData: json.decode(response.body) as Map,
            searchString: searchString);
        fs.updateDocument();
      }
    } catch (err) {
      print(err);
    }
  }
}
