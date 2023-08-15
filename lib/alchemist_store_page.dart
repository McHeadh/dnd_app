import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'item_page.dart';

class AlchemistStorePage extends StatefulWidget {
  const AlchemistStorePage({super.key});

  @override
  State<AlchemistStorePage> createState() => _AlchemistStorePageState();
}

class _AlchemistStorePageState extends State<AlchemistStorePage> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response =
        await http.get(Uri.parse('$baseApiUrl/items/AlchemistStore/Names'));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          items = List<Map<String, dynamic>>.from(json.decode(response.body));
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to fetch names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Alchemist store items'),
        backgroundColor: Colors.green,
      ),
      body: isLoading // Check if data is still loading
          ? const Center(
              child:
                  CircularProgressIndicator(), // Show a loading indicator while fetching data
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 300,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          if (item['isVisible']) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ItemPage(item['itemID']),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.black,
                                  minimumSize: const Size(300, 40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(item['name']),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
