import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kelimeezberle/db/db/db.dart';
import 'package:kelimeezberle/db/models/words.dart';

class WordCardsPage extends StatefulWidget {
  const WordCardsPage({Key? key}) : super(key: key);

  @override
  State<WordCardsPage> createState() => _WordCardsPageState();
}

enum Which { learn, unlearned, all }

enum forWhat { forList, forListMixed }

class _WordCardsPageState extends State<WordCardsPage> {
  Which? _chooseQuestionType = Which.learn;
  bool listMixed = true;
  List<Map<String, Object?>> _lists = [];
  List<bool> selectedListIndex = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.getListAll();
    for (int i = 0; i < _lists.length; ++i) {
      selectedListIndex.add(false);
    }
    setState(() {
      _lists;
    });
  }

  List<Word> _words = [];

  bool start = false;

  List<bool> changeLang = [];

  void getSelectedWordOfLists(List<int> selectedListID) async {
    if (_chooseQuestionType == Which.learn) {
      _words = await DB.instance.getWordByLists(selectedListID, status: true);
    } else if (_chooseQuestionType == Which.unlearned) {
      _words = await DB.instance.getWordByLists(selectedListID, status: false);
    } else {
      _words = await DB.instance.getWordByLists(selectedListID);
    }

    if (_words.isNotEmpty) {
      for (int i = 0; i < _words.length; ++i) {
        changeLang.add(true);
      }

      if (listMixed) _words.shuffle();
      start = true;

      setState(() {
        _words;
        start;
      });
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
        child: start == false
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                padding: const EdgeInsets.only(left: 4, top: 10, right: 4),
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    whichRadioButton(
                        text: "Öğrenmediklerimi sor.", value: Which.unlearned),
                    whichRadioButton(
                        text: "Öğrendiklerimi sor.", value: Which.learn),
                    whichRadioButton(text: "Hepsini sor.", value: Which.all),
                    checkBox(
                        text: "Listeyi karıştır.", fWhat: forWhat.forListMixed),
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
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, bottom: 10, top: 10),
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      child: Scrollbar(
                        thickness: 5,
                        // ignore: deprecated_member_use
                        isAlwaysShown: true,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return checkBox(
                                index: index,
                                text: _lists[index]['name'].toString());
                          },
                          itemCount: _lists.length,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: () {
                          List<int> selectedIndexNoOfList = [];

                          for (int i = 0; i < selectedListIndex.length; ++i) {
                            if (selectedListIndex[i] == true) {
                              selectedIndexNoOfList.add(i);
                            }
                          }

                          List<int> selectedListIdList = [];

                          for (int i = 0;
                              i < selectedIndexNoOfList.length;
                              ++i) {
                            selectedListIdList.add(
                                _lists[selectedIndexNoOfList[i]]['list_id']
                                    as int);
                          }

                          if (selectedListIdList.isNotEmpty) {
                            getSelectedWordOfLists(selectedListIdList);
                          }
                        },
                        child: Text(
                          "Başla",
                          style: TextStyle(
                              fontFamily: "RobotoRegular",
                              fontSize: 18,
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : CarouselSlider.builder(
                options: CarouselOptions(
                  height: double.infinity,
                ),
                itemCount: _words.length,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  return Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (changeLang[itemIndex] == true) {
                              changeLang[itemIndex] = false;
                            } else {
                              changeLang[itemIndex] = true;
                            }

                            setState(() {
                              changeLang[itemIndex];
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 0, bottom: 16),
                            padding:
                                const EdgeInsets.only(left: 4, top: 10, right: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              changeLang[itemIndex]
                                  ? (_words[itemIndex].word_eng!)
                                  : (_words[itemIndex].word_tr!),
                              style: const TextStyle(
                                  fontFamily: "RobotoRegular",
                                  fontSize: 28,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: CheckboxListTile(
                          title: Text("Öğrendim"),
                          value: _words[itemIndex].status,
                          onChanged: (value) {
                            _words[itemIndex] =
                                _words[itemIndex].copy(status: value);
                            DB.instance.markAsLearned(
                                value!, _words[itemIndex].id as int);

                            setState(() {
                              _words[itemIndex];
                            });
                          },
                        ),
                      )
                    ],
                  );
                }),
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

  SizedBox checkBox(
      {int index = 0, String? text, forWhat fWhat = forWhat.forList}) {
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
          value:
              fWhat == forWhat.forList ? selectedListIndex[index] : listMixed,
          onChanged: (bool? value) {
            setState(() {
              if (fWhat == forWhat.forList) {
                selectedListIndex[index] = value!;
              } else {
                listMixed = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
