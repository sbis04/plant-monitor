import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';

import 'screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RealmApp.init('plant_monitor-empqo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlantMonitor',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
