import 'package:dnd_app/models/region_name.dart';

import 'enemy_characteristic.dart';

class Enemy {
  int enemyID;
  String name;
  List<String>? imageData;
  String? description;
  String? status;
  String? category;
  List<EnemyCharacteristic>? characteristics;
  bool isVisible;
  List<RegionName>? regions;

  Enemy({
    required this.enemyID,
    required this.name,
    this.imageData,
    this.description,
    this.status,
    this.category,
    this.characteristics,
    required this.isVisible,
    this.regions,
  });

  int get getEnemyID => enemyID;
  String get getName => name;
  List<String>? get getImagedata => imageData;
  String? get getDescription => description;
  String? get getCategory => category;
  String? get getStatus => status;
  bool get getIsVisible => isVisible;
  List<EnemyCharacteristic>? get getCharacteristics => characteristics;
  List<RegionName>? get getRegions => regions;

  factory Enemy.fromJson(Map<String, dynamic> json) {
    return Enemy(
      enemyID: json['enemyID'],
      name: json['name'],
      imageData: _convertToImageList(json['imageData']),
      description: json['description'],
      status: json['status'],
      category: json['category'],
      isVisible: json['isVisible'],
      characteristics: (json['characteristics'] as List<dynamic>?)
          ?.map((data) => EnemyCharacteristic.fromJson(data))
          .toList(),
      regions: (json['regions'] as List<dynamic>?)
          ?.map((data) => RegionName.fromJson(data))
          .toList(),
    );
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
