class EnemyCharacteristic {
  int enemyCharacteristicID;
  int enemyID;
  String value;

  EnemyCharacteristic({
    required this.enemyCharacteristicID,
    required this.enemyID,
    required this.value,
  });

  factory EnemyCharacteristic.fromJson(Map<String, dynamic> json) {
    return EnemyCharacteristic(
      enemyCharacteristicID: json['enemyCharacteristicID'],
      enemyID: json['enemyID'],
      value: json['value'],
    );
  }

  int get getCharacteristicID => enemyCharacteristicID;
  int get getEnemyID => enemyID;
  String get getValue => value;
}
