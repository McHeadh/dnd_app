import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class RealmMapPage extends StatelessWidget {
  const RealmMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eldoria: The Realm of Legends'),
        backgroundColor: Colors.green,
      ),
      body: PhotoView(
        imageProvider:
            const AssetImage('assets/images/EldoriaThe_Realm_of_Legends.jpg'),
          maxScale: 1.5,
          minScale: 0.1,
      ),
    );
  }
}
