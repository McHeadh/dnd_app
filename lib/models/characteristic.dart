class Characteristic {
  int characteristicID;
  int characterID;
  String value;

  Characteristic({
    required this.characteristicID,
    required this.characterID,
    required this.value,
  });

  factory Characteristic.fromJson(Map<String, dynamic> json) {
    return Characteristic(
      characteristicID: json['characteristicID'],
      characterID: json['characterID'],
      value: json['value'],
    );
  }

  int get getCharacteristicID => characteristicID;
  int get getCharacterID => characterID;
  String get getValue => value;
}
