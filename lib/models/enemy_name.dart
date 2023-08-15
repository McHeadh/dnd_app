class EnemyName {
  int enemyID;
  String name;
  bool isVisible;
  String? category;

  EnemyName({
    required this.enemyID,
    required this.name,
    required this.isVisible,
    this.category,
  });

  factory EnemyName.fromJson(Map<String, dynamic> json) {
    return EnemyName(
      enemyID: json['enemyID'],
      name: json['name'],
      isVisible: json['isVisible'],
      category: json['category'],
    );
  }

  int get getEnemyID => enemyID;
  String get getName => name;
  bool get getIsVisible => isVisible;
  String? get getCategory => category;
}
