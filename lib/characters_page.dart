import 'package:flutter/material.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Characters'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
