import 'dart:convert';
import 'dart:typed_data';

import 'package:dnd_app/models/item.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  final Item item;

  const ItemPage(this.item, {Key? key}) : super(key: key);

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Uint8List _imageBytes = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(widget.item.getName),
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
          if (widget.item.getDescription != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(widget.item.getDescription!)
            ),
        ],
      ),
    );
  }

  Future<void> _loadImage() async {
    try {
      String firstImageData = widget.item.getImagedata![0];
      Uint8List bytes = base64Decode(firstImageData);
      setState(() {
        _imageBytes = bytes;
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }
}
