class Item {
  int itemID;
  String name;
  List<String>? imageData;
  String? description;
  String? effect;
  String? rarity;
  int? price;
  String? shopType;
  bool isVisible;

  Item({
    required this.itemID,
    required this.name,
    this.imageData,
    this.description,
    this.effect,
    this.rarity,
    this.price,
    this.shopType,
    required this.isVisible,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemID: json['itemID'],
      name: json['name'],
      imageData: _convertToImageList(json['imageData']),
      description: json['description'],
      effect: json['effect'],
      rarity: json['rarity'],
      price: json['price'],
      shopType: json['shopType'],
      isVisible: json['isVisible'],
    );
  }

  

  int get getItemID => itemID;
  String get getName => name;
  List<String>? get getImagedata => imageData;
  String? get getDescription => description;
  String? get getEffect => effect;
  String? get getRarity => rarity;
  int? get getPrice => price;
  String? get getShopType => shopType;
  bool get getIsVisible => isVisible;
}

List<String>? _convertToImageList(dynamic imageData) {
  if (imageData == null) {
    return null; // If imageData is null in JSON, return null in Dart model
  } else if (imageData is List<dynamic>) {
    return imageData.map((e) => e.toString()).toList(); // If imageData is already a list, map it to List<String>
  } else if (imageData is String) {
    return [imageData]; // If imageData is a string, create a list with a single element containing that string
  } else {
    return null; // Handle other data types if necessary
  }
}
