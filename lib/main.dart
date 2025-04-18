import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/screens/grocery_list.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: Color.fromARGB(255, 42, 51, 59)
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 50, 58, 60)
      ),
     home: GroceryList(),
    );
  }
}
