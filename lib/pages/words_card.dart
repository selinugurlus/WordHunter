import 'package:flutter/material.dart';

class WordCardsPage extends StatefulWidget {
  const WordCardsPage({Key? key}) : super(key: key);

  @override
  State<WordCardsPage> createState() => _WordCardsPageState();
}

enum Which { learn, unlearned, all }

class _WordCardsPageState extends State<WordCardsPage> {
  Which? _chooseQuestionType = Which.learn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.2,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text("Kelime Kartları"),
              color: Colors.purpleAccent,
            ),
            Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 35,
                  width: 35,
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              whichRadioButton(
                  text: "Öğrenmediklerimi sor.", value: Which.unlearned),
              whichRadioButton(text: "Öğrendiklerimi sor.", value: Which.learn),
              whichRadioButton(text: "Hepsini sor.", value: Which.all),
              checkBox(text: "Listeyi karıştır."),
              const Divider(
                color: Colors.black,
                thickness: 1,
              ),
              Text(
                "Listeler",
                style: const TextStyle(
                  fontFamily: "RobotoRegular",
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox whichRadioButton({@required String? text, @required Which? value}) {
    return SizedBox(
      width: 300,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Radio<Which>(
          value: value!,
          groupValue: _chooseQuestionType,
          onChanged: (Which? value) {
            setState(() {
              _chooseQuestionType = value;
            });
          },
        ),
      ),
    );
  }

  SizedBox checkBox({String? text}) {
    return SizedBox(
      width: 278,
      height: 35,
      child: ListTile(
        title: Text(
          text!,
          style: const TextStyle(fontFamily: "RobotoRegular", fontSize: 18),
        ),
        leading: Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.pinkAccent,
          hoverColor: Colors.purpleAccent,
          value: true,
          onChanged: (bool? value) {},
        ),
      ),
    );
  }
}
