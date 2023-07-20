import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CharacterSheetPage extends StatelessWidget {
  const CharacterSheetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheet'),
        backgroundColor: Colors.green,
      ),
      body: const WebView(
        initialUrl: 'https://www.dndbeyond.com/sheet-pdfs/McHead_99220714.pdf',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}