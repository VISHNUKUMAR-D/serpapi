class FireData {
  final String Date;
  final String Search;
  final String Domain1;
  final String Domain2;
  final String Domain3;
  final String Link1;
  final String Link2;
  final String Link3;
  final String Title1;
  final String Title2;
  final String Title3;

  FireData(
      {required this.Date,
      required this.Search,
      required this.Domain1,
      required this.Domain2,
      required this.Domain3,
      required this.Link1,
      required this.Link2,
      required this.Link3,
      required this.Title1,
      required this.Title2,
      required this.Title3});

  Map<String, dynamic> toJSON() => {
        'Date': Date,
        'Search': Search,
        'Domain1': Domain1,
        'Domain2': Domain2,
        'Domain3': Domain3,
        'Link1': Link1,
        'Link2': Link2,
        'Link3': Link3,
        'Title1': Title1,
        'Title2': Title2,
        'Title3': Title3
      };
  static FireData fromJSON(Map<String, dynamic> json) => FireData(
      Date: json["Date"],
      Search: json["Search"],
      Domain1: json["Domain1"],
      Domain2: json["Domain2"],
      Domain3: json["Domain3"],
      Link1: json["Link1"],
      Link2: json["Link2"],
      Link3: json["Link3"],
      Title1: json["Title1"],
      Title2: json["Title2"],
      Title3: json["Title3"]);
}
