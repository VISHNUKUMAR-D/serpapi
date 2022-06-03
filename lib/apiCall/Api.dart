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
      response = await http.get(Uri.parse("https://serpapi.com/search.json?" +
          "q=" +
          searchString +
          "&" +
          "google_domain=google.com" +
          "&gl=" +
          country +
          "&hl=en&api_key=" +
          "a1d474e2bc26f3e412e626d0b206e5942d704bedd9790ccc2f9253325676f9a9"));
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
