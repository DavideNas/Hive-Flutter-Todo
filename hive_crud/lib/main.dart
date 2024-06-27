import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // create directory for DB Hive
  final documentsDir = await getApplicationCacheDirectory();
  // initialize hive
  Hive.init(documentsDir.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Hive ToDo'),
    );
  }
}
