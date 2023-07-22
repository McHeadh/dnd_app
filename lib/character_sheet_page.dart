import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class CharacterSheetPage extends StatelessWidget {
  const CharacterSheetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Sheet'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: FutureBuilder<String>(
          future: downloadPDFAndSaveToLocal(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading PDF'));
              } else {
                return PDFView(filePath: snapshot.data!);
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

Future<String> downloadPDFAndSaveToLocal() async {
    String pdfURL = 'https://www.dndbeyond.com/sheet-pdfs/McHead_99220714.pdf';

    final response = await http.get(Uri.parse(pdfURL));

    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;

      String dir = (await getApplicationDocumentsDirectory()).path;
      String pdfPath = '$dir/CharacterSheet.pdf';

      await io.File(pdfPath).writeAsBytes(bytes);

      return pdfPath;
    } else {
      throw Exception('Failed to download PDF');
    }
  }