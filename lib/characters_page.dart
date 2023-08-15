import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'character_page.dart';

class CharactersPage extends StatefulWidget {
  final String? category;

  const CharactersPage({super.key, this.category});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  List<Map<String, dynamic>> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    String? baseApiUrl = dotenv.env['API_URL'];

    http.Response response;

    if (widget.category != null) {
      response = await http.get(Uri.parse(
          '$baseApiUrl/Characters/Names/byCategory?category=${widget.category}'));
    } else {
      response = await http.get(Uri.parse('$baseApiUrl/Characters/Names'));
    }

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          characters =
              List<Map<String, dynamic>>.from(json.decode(response.body));
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
        title: Text(widget.category ?? 'Characters'),
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
                        itemCount: characters.length,
                        itemBuilder: (context, index) {
                          final character = characters[index];
                          print(character);
                          if (character['isVisible']) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CharacterPage(character['characterID']),
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
                                child: Text(character['name']),
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
