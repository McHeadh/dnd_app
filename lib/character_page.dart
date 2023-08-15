import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/character.dart';

class CharacterPage extends StatefulWidget {
  final int characterId;

  const CharacterPage(this.characterId, {Key? key}) : super(key: key);

  @override
  State<CharacterPage> createState() => _CharacterPageState();
}

class _CharacterPageState extends State<CharacterPage> {
  Character? character;
  Uint8List _imageBytes = Uint8List(0);
  bool isCharacterInitialized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCharacterById(widget.characterId);
  }

  Future<void> fetchCharacterById(int characterId) async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response =
        await http.get(Uri.parse('$baseApiUrl/Characters/$characterId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Character characterData = Character.fromJson(data);
      if (mounted) {
        setState(() {
          character = characterData;
          isCharacterInitialized = true;
          isLoading = false;
        });
        _loadImage();
      }
    } else {
      throw Exception('Failed to fetch character by ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(character?.getName ?? 'Character Details'),
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
                    if (character?.getDescription != null &&
                        character!.getDescription!.isNotEmpty)
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
                                character?.getDescription ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (character?.getPositionInTown != null &&
                        character!.getPositionInTown!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.green,
                          backgroundColor: Colors.greenAccent,
                          title: const Text(
                            'Position in town',
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
                                character?.getPositionInTown ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (character?.getCharacteristics != null &&
                        character!.getCharacteristics!.isNotEmpty)
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
                                  character!.getCharacteristics!.map((charac) {
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
                    if (character?.getStatus != null &&
                        character!.getStatus!.isNotEmpty)
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
                                character?.getStatus ?? '',
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
      if (character?.getImagedata != null &&
          character!.getImagedata!.isNotEmpty) {
        String firstImageData = character!.getImagedata![0];
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
