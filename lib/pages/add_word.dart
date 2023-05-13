// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:kelimeezberle/db/db/db.dart';
import 'package:kelimeezberle/db/models/words.dart';

class AddWordPage extends StatefulWidget {
  final int? listID;
  final String? listName;

  const AddWordPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  State<AddWordPage> createState() =>
      _AddWordPageState(listID: listID, listName: listName);
}

class _AddWordPageState extends State<AddWordPage> {
  int? listID;
  String? listName;

  _AddWordPageState({@required this.listID, @required this.listName});

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 6; ++i) {
      wordTextEditingList.add(TextEditingController());
    }

    for (int i = 0; i < 3; ++i) {
      wordListField.add(
        Row(
          children: [
            Expanded(
                child: textFieldBuilder(
                    textEditingController: wordTextEditingList[2 * i])),
            Expanded(
                child: textFieldBuilder(
                    textEditingController: wordTextEditingList[2 * i + 1]))
          ],
        ),
      );
    }
  }

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
              child: Text(
                listName!.toString(),
                style: TextStyle(
                    fontFamily: "carter",
                    fontSize: 22,
                    color: Colors.pinkAccent),
              ),
            ),
            Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Icon(Icons.add),
                color: Colors.purpleAccent),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "İngilizce",
                      style:
                          TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                    ),
                    Text(
                      "Türkçe",
                      style:
                          TextStyle(fontSize: 18, fontFamily: "RobotoRegular"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: wordListField,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  actionBtn(addRow, Icons.add),
                  actionBtn(save, Icons.save),
                  actionBtn(deleteRow, Icons.remove)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addRow() {
    wordTextEditingList.add(TextEditingController());
    wordTextEditingList.add(TextEditingController());

    wordListField.add(
      Row(
        children: [
          Expanded(
              child: textFieldBuilder(
                  textEditingController:
                      wordTextEditingList[wordTextEditingList.length - 2])),
          Expanded(
              child: textFieldBuilder(
                  textEditingController:
                      wordTextEditingList[wordTextEditingList.length - 1]))
        ],
      ),
    );

    setState(() => wordListField);
  }

  void save() async {
    int counter = 0;
    bool notEmptyPair = false;

    //burda en az 4 kelime çifti girilmesi gerektiğini ve boş kalmamasını kontrol ediyo.
    for (int i = 0; i < wordTextEditingList.length / 2; ++i) {
      String eng = wordTextEditingList[2 * i].text;
      String tr = wordTextEditingList[2 * i + 1].text;

      if (!eng.isEmpty && !tr.isEmpty) {
        counter++;
      } else {
        notEmptyPair = true;
      }
    }

    if (counter >= 1) {
      if (notEmptyPair == false) {
        for (int i = 0; i < wordTextEditingList.length / 2; i++) {
          String eng = wordTextEditingList[2 * i].text;
          String tr = wordTextEditingList[2 * i + 1].text;

          Word word = await DB.instance.insertWord(
              Word(list_id: listID, word_eng: eng, word_tr: tr, status: false));

          debugPrint(word.id.toString() +
              " " +
              word.list_id.toString() +
              " " +
              word.word_eng.toString() +
              " " +
              word.word_tr.toString() +
              " " +
              word.status.toString());
        }
      }
    } else {
      debugPrint("TOAST MESSAGE=>MİN 1 ÇİFT DOLU OLMALI.");
    }
  }

  void deleteRow() {
    if (wordListField.length != 1) {
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);
      wordTextEditingList.removeAt(wordTextEditingList.length - 1);

      wordListField.removeAt(wordListField.length - 1);
      setState(() => wordListField);
    } else {
      debugPrint("son 1 eleman");
    }
  }

  Container textFieldBuilder(
      {int height = 40,
      @required TextEditingController? textEditingController,
      Icon? icon,
      String? hintText,
      TextAlign textAlign = TextAlign.center}) {
    return Container(
      height: double.parse(height.toString()),
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: TextField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        textAlign: textAlign,
        controller: textEditingController,
        style: TextStyle(
            color: Colors.black,
            fontFamily: "RobotoMedium",
            decoration: TextDecoration.none,
            fontSize: 18),
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.transparent,
          isDense: true,
        ),
      ),
    );
  }
}

InkWell actionBtn(Function() click, IconData icon) {
  return InkWell(
    onTap: () => click(),
    child: Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(bottom: 10),
      child: Icon(
        icon,
        size: 28,
      ),
      decoration: BoxDecoration(
        color: Colors.pinkAccent,
        shape: BoxShape.circle,
      ),
    ),
  );

  Container textFieldBuilder(
      {int height = 40,
      @required TextEditingController? textEditingController,
      Icon? icon,
      String? hintText,
      TextAlign textAlign = TextAlign.center}) {
    return Container(
      height: double.parse(height.toString()),
      padding: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
          color: Colors.grey, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
      child: TextField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        textAlign: textAlign,
        controller: textEditingController,
        style: TextStyle(
            color: Colors.black,
            fontFamily: "RobotoMedium",
            decoration: TextDecoration.none,
            fontSize: 18),
        decoration: InputDecoration(
          icon: icon,
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.transparent,
          isDense: true,
        ),
      ),
    );
  }
}
