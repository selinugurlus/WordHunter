import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/lists.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

enum Lang { eng, tr }

class _MainPageState extends State<MainPage> {
  Lang? _chooseLang = Lang.eng;

  final GlobalKey<ScaffoldState> _scaffdolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffdolKey,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        color: Colors.white,
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: InkWell(
                  onTap: () {
                    _scaffdolKey.currentState!.openDrawer();
                  },
                  child: Icon(
                    Icons.drag_handle,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(
                  "assets/images/logo_text.png",
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                langRadioButton(
                  text: 'İngilizce-Türkçe',
                  group: _chooseLang,
                  value: Lang.tr,
                ),
                langRadioButton(
                  text: 'Türkçe-İngilizce',
                  group: _chooseLang,
                  value: Lang.eng,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListsPage()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(
                      "LİSTELERİM",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Carter",
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 150,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.indigoAccent,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    "KELİME KARTLARI",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Carter",
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Text(
                    "ÇOKTAN SEÇMELİ",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: "Carter",
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox langRadioButton({
    @required String? text,
    @required Lang? value,
    @required Lang? group,
  }) {
    return SizedBox(
      width: 250,
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          text!,
          style: TextStyle(fontFamily: "Carter", fontSize: 15),
        ),
        leading: Radio<Lang>(
          value: Lang.tr,
          groupValue: _chooseLang,
          onChanged: (Lang? value) {
            setState(() {
              _chooseLang = value;
            });
          },
        ),
      ),
    );
  }
}
