import 'package:cloud_firestore/cloud_firestore.dart';

import 'FireData.dart';
import 'DataStore.dart';

class FireStore {
  Map mapData;
  DataStore data = DataStore();
  String searchString;
  late String DomainName;
  FireStore({required this.mapData, required this.searchString}) {
    searchString = searchString.replaceAll("+", " ");
    data.Search = searchString;
    data.Date = DateTime.now().year.toString() +
        "-" +
        ((int.parse(DateTime.now().month.toString()) < 10)
            ? ("0" + DateTime.now().month.toString())
            : DateTime.now().month.toString()) +
        "-" +
        ((int.parse(DateTime.now().day.toString()) < 10)
            ? ("0" + DateTime.now().day.toString())
            : DateTime.now().day.toString());
    // data.Time = DateTime.now().hour.toString() +
    //     ":" +
    //     DateTime.now().minute.toString() +
    //     ":" +
    //     DateTime.now().second.toString();
    data.Link1 = mapData['organic_results'][0]['link'];
    data.Link2 = mapData['organic_results'][1]['link'];
    data.Link3 = mapData['organic_results'][2]['link'];
    data.Domain1 = data.Link1.substring(
        data.Link1.indexOf(".") + 1, data.Link1.lastIndexOf("."));
    data.Domain2 = data.Link2.substring(
        data.Link2.indexOf(".") + 1, data.Link2.lastIndexOf("."));
    data.Domain3 = data.Link3.substring(
        data.Link3.indexOf(".") + 1, data.Link3.lastIndexOf("."));
    data.Title1 = mapData['organic_results'][0]['title'];
    data.Title2 = mapData['organic_results'][1]['title'];
    data.Title3 = mapData['organic_results'][2]['title'];
    DomainName = data.Domain1;
  }

  Future updateDocument() async {
    final docData =
        FirebaseFirestore.instance.collection('serpdata').doc(data.Date);
    final result = FireData(
        Date: data.Date,
        Search: data.Search,
        Domain1: data.Domain1,
        Domain2: data.Domain2,
        Domain3: data.Domain3,
        Link1: data.Link1,
        Link2: data.Link2,
        Link3: data.Link3,
        Title1: data.Title1,
        Title2: data.Title2,
        Title3: data.Title3);

    await docData.set(result.toJSON());
    final docDomain =
        FirebaseFirestore.instance.collection('TopWebsite').doc(data.Search);
    await docDomain.set({'Domain': data.Domain1});
  }
}
