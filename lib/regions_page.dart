import 'dart:convert';
import 'package:dnd_app/region_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegionsPage extends StatefulWidget {
  const RegionsPage({super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  List<Map<String, dynamic>> regions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  Future<void> fetchRegions() async {
    String? baseApiUrl = dotenv.env['API_URL'];
    final response = await http.get(Uri.parse('$baseApiUrl/Regions/Names'));

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          regions = List<Map<String, dynamic>>.from(json.decode(response.body));
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
        title: const Text('Regions'),
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
                        itemCount: regions.length,
                        itemBuilder: (context, index) {
                          final region = regions[index];
                          print(region);
                          if (region['isVisible']) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegionPage(region['regionID']),
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
                                child: Text(region['name']),
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
