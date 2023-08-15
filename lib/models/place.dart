class Place {
  int placeID;
  String name;
  String? description;
  List<String>? imageData;
  bool isVisible;
  int regionID;

  Place({
    required this.placeID,
    required this.regionID,
    required this.name,
    required this.isVisible,
    this.description,
    this.imageData,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeID: json['placeID'],
      name: json['name'],
      imageData: _convertToImageList(json['imageData']),
      description: json['description'],
      isVisible: json['isVisible'],
      regionID: json['regionID'],
    );
  }

  int get getPlaceID => placeID;
  String get getName => name;
  List<String>? get getImagedata => imageData;
  String? get getDescription => description;
  bool get getIsVisible => isVisible;
  int get getRegionID => regionID;
}

List<String>? _convertToImageList(dynamic imageData) {
  if (imageData == null) {
    return null; // If imageData is null in JSON, return null in Dart model
  } else if (imageData is List<dynamic>) {
    return imageData
        .map((e) => e.toString())
        .toList(); // If imageData is already a list, map it to List<String>
  } else if (imageData is String) {
    return [
      imageData
    ]; // If imageData is a string, create a list with a single element containing that string
  } else {
    return null; // Handle other data types if necessary
  }
}
