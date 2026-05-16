import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => TodoProvider(),
      child: MaterialApp(
        title: 'Todo CRUD',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}