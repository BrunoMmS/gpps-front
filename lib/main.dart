import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Center(child: Text("Byte Builders", 
                                style: TextStyle(fontSize: 48, 
                                  fontWeight: FontWeight.bold, 
                                  wordSpacing: 7, 
                                  color: Colors.blueAccent),)),
    );
  }
}

