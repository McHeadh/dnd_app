import 'package:dnd_app/models/enemy_name.dart';
import 'package:dnd_app/models/place_name.dart';

class Region {
  int regionID;
  String name;
  String? description;
  List<String>? imageData;
  bool isVisible;
  List<EnemyName>? enemies;
  List<PlaceName>? places;

  Region({
    required this.regionID,
    required this.name,
    required this.isVisible,
    this.description,
    this.imageData,
    this.enemies,
    this.places,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      regionID: json['regionID'],
      name: json['name'],
      imageData: _convertToImageList(json['imageData']),
      description: json['description'],
      isVisible: json['isVisible'],
      enemies: (json['enemies'] as List<dynamic>?)
          ?.map((data) => EnemyName.fromJson(data))
          .toList(),
      places: (json['places'] as List<dynamic>?)
          ?.map((data) => PlaceName.fromJson(data))
          .toList(),
    );
  }

  int get getRegionID => regionID;
  String get getName => name;
  List<String>? get getImagedata => imageData;
  String? get getDescription => description;
  bool get getIsVisible => isVisible;
  List<EnemyName>? get getEnemies => enemies;
  List<PlaceName>? get getPlaces => places;

  List<EnemyName>? getEnemiesByCategory(String category) {
    return getEnemies?.where((enemy) => enemy.getCategory == category).toList();
  }
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
