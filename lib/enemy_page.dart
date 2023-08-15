import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/enemy.dart';

class EnemyPage extends StatefulWidget {
  final int enemyId;

  const EnemyPage(this.enemyId, {Key? key}) : super(key: key);

  @override
  State<EnemyPage> createState() => _EnemyPageState();
}

class _EnemyPageState extends State<EnemyPage> {
  Enemy? enemy;
  Uint8List _imageBytes = Uint8List(0);
  bool isEnemyInitialized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnemyById(widget.enemyId);
  }

  Future<void> fetchEnemyById(int enemyId) async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response = await http.get(Uri.parse('$baseApiUrl/Enemies/$enemyId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Enemy enemyData = Enemy.fromJson(data);
      if (mounted) {
        setState(() {
          enemy = enemyData;
          isEnemyInitialized = true;
          isLoading = false;
        });
        _loadImage();
      }
    } else {
      throw Exception('Failed to fetch enemy by ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(enemy?.getName ?? 'Enemy Details'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Column(
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
                    if (enemy?.getDescription != null &&
                        enemy!.getDescription!.isNotEmpty)
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
                                enemy?.getDescription ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (enemy?.getCharacteristics != null &&
                        enemy!.getCharacteristics!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.green,
                          backgroundColor: Colors.greenAccent,
                          title: const Text(
                            'Characteristics',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          children: [
                            Column(
                              children:
                                  enemy!.getCharacteristics!.map((charac) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    charac.getValue,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    if (enemy?.getStatus != null &&
                        enemy!.getStatus!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.green,
                          backgroundColor: Colors.greenAccent,
                          title: const Text(
                            'Status',
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
                                enemy?.getStatus ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
    );
  }

  Future<void> _loadImage() async {
    try {
      if (enemy?.getImagedata != null && enemy!.getImagedata!.isNotEmpty) {
        String firstImageData = enemy!.getImagedata![0];
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
