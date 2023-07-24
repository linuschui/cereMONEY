import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ceremoney/data/expense_data.dart';
import 'package:ceremoney/pages/home.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("cereMONEY_database_v3");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ExpenseData(),
        builder: (context, child) => const MaterialApp(
            debugShowCheckedModeBanner: false, home: HomePage()));
  }
}
