import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/place.dart';

class PlacePage extends StatefulWidget {
  final int placeId;

  const PlacePage(this.placeId, {Key? key}) : super(key: key);

  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  Place? place;
  Uint8List _imageBytes = Uint8List(0);
  bool isPlaceInitialized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaceById(widget.placeId);
  }

  Future<void> fetchPlaceById(int placeId) async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response = await http.get(Uri.parse('$baseApiUrl/Places/$placeId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Place placeData = Place.fromJson(data);
      if (mounted) {
        setState(() {
          place = placeData;
          isPlaceInitialized = true;
          isLoading = false;
        });
        _loadImage();
      }
    } else {
      throw Exception('Failed to fetch place by ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(place?.getName ?? 'Place Details'),
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
                    if (place?.getDescription != null &&
                        place!.getDescription!.isNotEmpty)
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
                                place?.getDescription ?? '',
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
      if (place?.getImagedata != null && place!.getImagedata!.isNotEmpty) {
        String firstImageData = place!.getImagedata![0];
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
