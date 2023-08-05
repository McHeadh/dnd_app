import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    checkAndUpdate();
  }

  Future<void> checkAndUpdate() async {
    bool hasUpdates = await checkForUpdates();
    if (hasUpdates) {
      // ignore: use_build_context_synchronously
      showUpdateAlertDialog(context); // Show the update alert dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to DnD Helper',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
            const Text(
              'Work in progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const HomePage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              child: const Text('Continue without logging in'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateAlertDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('New Update Available'),
          content: const Text(
              'There is a new version of the app available. Do you want to update now?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without updating
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Implement the update process here, such as redirecting to app store
                // or performing an in-app update using a package like `flutter_inappupdate`.
                // For the sake of this example, we will just close the dialog.
                updateApp();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

Future<String> readVersionFile() async {
  String contents;
  try {
    contents = await rootBundle.loadString('.version');
  } catch (error) {
    contents = ''; // Handle the case when the version file cannot be read
  }
  return contents;
}

Future<String> getGithubVersion() async {
  String? githubVersionURL = dotenv.env['GITHUB_VERSION_URL'];
  String version = '';

  try {
    final response = await http.get(Uri.parse('$githubVersionURL'));

    if (response.statusCode == 200) {
      version = response.body.trim();
    } else {
      throw Exception('Failed to fetch GitHub version');
    }
  } catch (e) {
    // Handle any network-related errors
    print('Error fetching GitHub version: $e');
    throw Exception('Failed to fetch GitHub version');
  }

  return version;
}

Future<bool> checkForUpdates() async {
  String localVersion = await readVersionFile();
  String githubVersion = await getGithubVersion();

  if (localVersion.isNotEmpty && localVersion != githubVersion) {
    print('There is new version avaliable');
    return true;
  } else {
    print('Current version is up to date');
    return false;
  }
}

Future<void> updateApp() async {
  // Replace "your_update_url" with the URL where the updated APK is hosted.
  String? githubApkURL = dotenv.env['GITHUB_APK_URL'];

  // Download the updated APK to a temporary directory
  final tempDir = await getTemporaryDirectory();
  final updatedApkPath = "${tempDir.path}/app-debug.apk";

  final response = await http.get(Uri.parse(githubApkURL!));
  if (response.statusCode == 200) {
    
    final file = File(updatedApkPath);
    await file.writeAsBytes(response.bodyBytes);
    print('Downloaded newer version');

    // Install the updated APK
    final success = await OpenFile.open(updatedApkPath);
  }

}
