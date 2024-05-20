import 'package:flutter/material.dart';
import 'package:to_do_app_firebase_realtime_db/todolist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "To_Do_LIST",
      debugShowCheckedModeBanner: false,
      home: MyToDoList(),
    );
  }
}
