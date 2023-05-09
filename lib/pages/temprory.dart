import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/main.dart';

class TemproryPage extends StatefulWidget {
  const TemproryPage({Key? key}) : super(key: key);

  @override
  State<TemproryPage> createState() => _TemproryPageState();
}

class _TemproryPageState extends State<TemproryPage> {
  //2 sn bu sayfada beklesin sonra diğer sayfaya geçsin
  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      },
    );
  }

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
