import 'dart:convert';
import 'dart:typed_data';
import 'package:dnd_app/models/enemy_name.dart';
import 'package:dnd_app/place_page.dart';
import 'package:http/http.dart' as http;
import 'package:dnd_app/models/region.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'enemy_page.dart';

class RegionPage extends StatefulWidget {
  final int regionId;

  const RegionPage(this.regionId, {Key? key}) : super(key: key);

  @override
  State<RegionPage> createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  Region? region;
  Uint8List _imageBytes = Uint8List(0);
  bool isRegionInitialized = false;
  bool isLoading = true;

  List<EnemyName> commonEnemies = [];
  List<EnemyName> bosses = [];

  @override
  void initState() {
    super.initState();
    fetchRegionById(widget.regionId);
  }

  Future<void> fetchRegionById(int regionId) async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response = await http.get(Uri.parse('$baseApiUrl/Regions/$regionId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Region regionData = Region.fromJson(data);
      if (mounted) {
        setState(() {
          region = regionData;
          isRegionInitialized = true;
          isLoading = false;
        });
        _loadImage();
        _categorizeEnemies();
      }
    } else {
      throw Exception('Failed to fetch region by ID');
    }
  }

  void _categorizeEnemies() {
    commonEnemies = region?.getEnemiesByCategory('normalFoes') ?? [];
    bosses = region?.getEnemiesByCategory('elitesBosses') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(region?.getName ?? 'Region Details'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    children: [
                      if (_imageBytes.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: SizedBox(
                              width: 200,
                              child: Image.memory(_imageBytes),
                            ),
                          ),
                        ),
                      if (region?.getDescription != null &&
                          region!.getDescription!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.green,
                            backgroundColor: Colors.greenAccent,
                            title: const Text(
                              'Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  region?.getDescription ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (commonEnemies.any((enemy) => enemy.getIsVisible))
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.green,
                            backgroundColor: Colors.greenAccent,
                            title: const Text(
                              'Common enemies',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: commonEnemies
                                    .where((enemy) => enemy.getIsVisible)
                                    .length,
                                itemBuilder: (context, index) {
                                  var visibleEnemies = commonEnemies
                                      .where((enemy) => enemy.getIsVisible)
                                      .toList();
                                  var enemy = visibleEnemies[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EnemyPage(enemy.enemyID),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.black,
                                        //minimumSize: const Size(200, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(enemy.getName),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (bosses.any((enemy) => enemy.getIsVisible))
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.green,
                            backgroundColor: Colors.greenAccent,
                            title: const Text(
                              'Bosses',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: bosses
                                    .where((enemy) => enemy.getIsVisible)
                                    .length,
                                itemBuilder: (context, index) {
                                  var visibleEnemies = bosses
                                      .where((enemy) => enemy.getIsVisible)
                                      .toList();
                                  var enemy = visibleEnemies[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EnemyPage(enemy.enemyID),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.black,
                                        //minimumSize: const Size(200, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(enemy.getName),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      if (region?.getPlaces
                              ?.where((place) => place.getIsVisible)
                              .isEmpty ==
                          false)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.green,
                            backgroundColor: Colors.greenAccent,
                            title: const Text(
                              'Places',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: region?.getPlaces
                                        ?.where((place) => place.getIsVisible)
                                        .length ??
                                    0,
                                itemBuilder: (context, index) {
                                  var visiblePlaces = region?.getPlaces
                                          ?.where((place) => place.getIsVisible)
                                          .toList() ??
                                      [];
                                  var place = visiblePlaces[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PlacePage(place.getPlaceID),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.black,
                                        //minimumSize: const Size(200, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text(place.getName),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _loadImage() async {
    try {
      if (region?.getImagedata != null && region!.getImagedata!.isNotEmpty) {
        String firstImageData = region!.getImagedata![0];
        Uint8List bytes = base64Decode(firstImageData);
        setState(() {
          _imageBytes = bytes;
        });
      } else {
        // Handle the case when the image data is null or empty
      }
    } catch (e) {
      throw ('Error loading image: $e');
    }
  }
}
