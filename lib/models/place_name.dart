class PlaceName {
  int placeID;
  String name;
  bool isVisible;

  PlaceName({
    required this.placeID,
    required this.name,
    required this.isVisible,
  });

  factory PlaceName.fromJson(Map<String, dynamic> json) {
    return PlaceName(
      placeID: json['placeID'],
      name: json['name'],
      isVisible: json['isVisible'],
    );
  }

  int get getPlaceID => placeID;
  String get getName => name;
  bool get getIsVisible => isVisible;
}
