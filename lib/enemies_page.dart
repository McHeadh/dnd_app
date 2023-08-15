import 'dart:convert';

import 'package:dnd_app/enemy_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class EnemiesPage extends StatefulWidget {
  final String? category;

  const EnemiesPage({super.key, this.category});

  @override
  State<EnemiesPage> createState() => _EnemiesPageState();
}

class _EnemiesPageState extends State<EnemiesPage> {
  List<Map<String, dynamic>> enemies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnemies();
  }

  Future<void> fetchEnemies() async {
    String? baseApiUrl = dotenv.env['API_URL'];

    http.Response response;

    if (widget.category != null) {
      response = await http.get(Uri.parse(
          '$baseApiUrl/Enemies/Names/byCategory?category=${widget.category}'));
    } else {
      response = await http.get(Uri.parse('$baseApiUrl/Enemies/Names'));
    }

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          enemies = List<Map<String, dynamic>>.from(json.decode(response.body));
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
        title: Text(widget.category ?? 'Enemies'),
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
                        itemCount: enemies.length,
                        itemBuilder: (context, index) {
                          final enemy = enemies[index];
                          print(enemy);
                          if (enemy['isVisible']) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EnemyPage(enemy['enemyID']),
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
                                child: Text(enemy['name']),
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
