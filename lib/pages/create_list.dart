import 'package:flutter/material.dart';

class CreateList extends StatefulWidget {
  const CreateList({Key? key}) : super(key: key);

  @override
  State<CreateList> createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final _listname = TextEditingController();

  List<TextEditingController> wordTextEditingList = [];
  List<Row> wordListField = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 10; i++)
      wordTextEditingList.add(TextEditingController());

    for (int i = 0; i < 5; i++) {
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
              child: Image.asset(
                "assets/images/lists.png",
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.2,
              child: Image.asset(
                "assets/images/logo.png",
                height: 35,
                width: 35,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              textFieldBuilder(
                icon: Icon(
                  Icons.list,
                  size: 18,
                ),
                hintText: "Liste Adı",
                textEditingController: _listname,
                textAlign: TextAlign.left,
              ),
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
              )
            ],
          ),
        ),
      ),
    );
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
