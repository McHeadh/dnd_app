class RegionName {
  int regionID;
  String name;
  bool isVisible;

  RegionName({
    required this.regionID,
    required this.name,
    required this.isVisible,
  });

  factory RegionName.fromJson(Map<String, dynamic> json) {
    return RegionName(
      regionID: json['regionID'],
      name: json['name'],
      isVisible: json['isVisible'],
    );
  }

  int get getRegionID => regionID;
  String get getName => name;
  bool get getIsVisible => isVisible;
}
