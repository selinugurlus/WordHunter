import 'package:flutter/material.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                Text("Word Hunter",
                    style: TextStyle(
                        color: Colors.black, fontFamily: "Luck", fontSize: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
