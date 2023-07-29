import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dnd_app/models/item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ItemPage extends StatefulWidget {
  final int itemId;

  const ItemPage(this.itemId, {Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Item? item;
  Uint8List _imageBytes = Uint8List(0);
  bool isItemInitialized = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItemById(widget.itemId);
  }

  Future<void> fetchItemById(int itemId) async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response = await http.get(Uri.parse('$baseApiUrl/items/$itemId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      Item itemData = Item.fromJson(data);
      if (mounted) {
        setState(() {
          item = itemData;
          isItemInitialized = true;
          isLoading = false;
        });
        _loadImage();
      }
    } else {
      throw Exception('Failed to fetch item by ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(item?.getName ?? 'Item Details'),
        backgroundColor: Colors.green,
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ExpansionTile(
              collapsedBackgroundColor: Colors.green,
              backgroundColor: Colors.grey,
              title: const Text(
                'Description',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              children: [
                Text(
                  item?.getDescription ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadImage() async {
    try {
      if (item?.getImagedata != null && item!.getImagedata!.isNotEmpty) {
        String firstImageData = item!.getImagedata![0];
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

/*
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
          //if (item?.getDescription != null)
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24, left: 24, right: 24),
                child: Text(
                  'Description: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              item?.getDescription ?? '',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  'Effect: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              item?.getEffect ?? '',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Text(
                  'Rarity: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              item?.getRarity ?? '',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
*/
