import 'dart:convert';
import 'package:dnd_app/item_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/item.dart';

class GeneralStorePage extends StatefulWidget {
  const GeneralStorePage({super.key});

  @override
  State<GeneralStorePage> createState() => _GeneralStorePageState();
}

class _GeneralStorePageState extends State<GeneralStorePage> {
  List<Item> itemList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response =
        await http.get(Uri.parse('$baseApiUrl/items/GeneralStore'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Item> items =
          List<Item>.from(data.map((itemJson) => Item.fromJson(itemJson)));
      setState(() {
        itemList = items;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch names');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('General store items'),
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
                        itemCount: itemList.length,
                        itemBuilder: (context, index) {
                          final item = itemList[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemPage(item),
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
                              child: Text(item.getName),
                            ),
                          );
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
