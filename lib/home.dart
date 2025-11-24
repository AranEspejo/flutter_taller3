import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsGeometry.all(50),
        child: Center(child: Text("My Home Page", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),),
        )
      ),
    );
  }
}