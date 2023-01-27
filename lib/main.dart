import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/task_data.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  await dataBaseHelper.init();
  var a = await dataBaseHelper.query();
  print(a);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}



