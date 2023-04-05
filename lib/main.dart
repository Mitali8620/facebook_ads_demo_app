import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FB Audience Facebook ads app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
          buttonColor: Colors.blue,
        ),
      ),
      home: const HomePage(),
    );
  }
}
