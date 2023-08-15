import 'characteristic.dart';

class Character {
  int characterID;
  String name;
  List<String>? imageData;
  String? description;
  String? positionInTown;
  String? status;
  String? category;
  List<Characteristic>? characteristics;
  bool isVisible;

  Character({
    required this.characterID,
    required this.name,
    this.imageData,
    this.description,
    this.positionInTown,
    this.status,
    this.category,
    this.characteristics,
    required this.isVisible,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      characterID: json['characterID'],
      name: json['name'],
      imageData: _convertToImageList(json['imageData']),
      description: json['description'],
      positionInTown: json['positionInTown'],
      status: json['status'],
      category: json['category'],
      isVisible: json['isVisible'],
      characteristics: (json['characteristics'] as List<dynamic>?)
          ?.map((data) => Characteristic.fromJson(data))
          .toList(),
    );
  }

  int get getCharacterID => characterID;
  String get getName => name;
  List<String>? get getImagedata => imageData;
  String? get getDescription => description;
  String? get getPositionInTown => positionInTown;
  String? get getCategory => category;
  String? get getStatus => status;
  bool get getIsVisible => isVisible;
  List<Characteristic>? get getCharacteristics => characteristics;
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
