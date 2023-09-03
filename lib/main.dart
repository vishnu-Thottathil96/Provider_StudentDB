import 'package:flutter/material.dart';
import 'package:providerstudentdb/view/splash/screen_splash.dart';

import 'controller/db_functions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DB.instance;
  await db.initialiseDatabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
