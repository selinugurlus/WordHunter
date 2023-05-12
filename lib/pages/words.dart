import 'package:flutter/material.dart';
import 'package:kelimeezberle/db/db/db.dart';
import 'package:kelimeezberle/db/models/words.dart';

class WordsPage extends StatefulWidget {
  final int? listID;
  final String? listName;

  const WordsPage(this.listID, this.listName, {Key? key}) : super(key: key);

  @override
  State<WordsPage> createState() =>
      _WordsPageState(listID: listID, listName: listName);
}

class _WordsPageState extends State<WordsPage> {
  int? listID;
  String? listName;

  _WordsPageState({@required this.listID, @required this.listName});

  List<Word> _wordList = [];

  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    super.initState();
    debugPrint(listID.toString() + " " + listName!);
    getWordByList();
  }

  void getWordByList() async {
    _wordList = await DB.instance.getWordByList(listID);
    for (int i = 0; i < _wordList.length; ++i) {
      deleteIndexList.add(false);
    }
    setState(() => _wordList);
  }

  void delete() async {
    List<int> removeIndexList = [];

    for (int i = 0; i < deleteIndexList.length; ++i) {
      if (deleteIndexList[i] == true) {
        removeIndexList.add(i);
      }
    }

    for (int i = removeIndexList.length - 1; i >= 0; --i) {
      DB.instance.deleteWord(_wordList[removeIndexList[i]].id!);
      _wordList.removeAt(removeIndexList[i]);
      deleteIndexList.removeAt(removeIndexList[i]);
    }

    setState(() {
      _wordList;
      deleteIndexList;
      pressController = false;
    });
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
              child: pressController != true
                  ? Image.asset(
                      "assets/images/logo.png",
                      height: 35,
                      width: 35,
                    )
                  : InkWell(
                      onTap: delete,
                      child: Icon(Icons.delete,
                          color: Colors.purpleAccent, size: 24),
                    ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return wordItem(
              _wordList[index].id!,
              index,
              word_eng: _wordList[index].word_eng,
              word_tr: _wordList[index].word_tr,
              status: _wordList[index].status!,
            );
          },
          itemCount: _wordList.length,
        ),
      ),
    );
  }

  InkWell wordItem(int wordId, int index,
      {@required String? word_tr,
      @required String? word_eng,
      @required bool? status}) {
    return InkWell(
      onLongPress: () {
        setState(() {
          pressController = true;
          deleteIndexList[index] = true;
        });
      },
      child: Center(
        child: Container(
          width: double.infinity,
          child: Card(
            color: Colors.white70,
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 10),
                      child: Text(word_tr!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: "RobotoMedium")),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 10),
                      child: Text(word_eng!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "RobotoRegular")),
                    ),
                  ],
                ),
                pressController != true
                    ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.pinkAccent,
                        hoverColor: Colors.purpleAccent,
                        value: status,
                        onChanged: (bool? value) {
                          _wordList[index] =
                              _wordList[index].copy(status: value);
                          if (value == true) {
                            DB.instance.markAsLearned(
                                true, _wordList[index].id as int);
                          } else {
                            DB.instance.markAsLearned(
                                false, _wordList[index].id as int);
                          }
                          setState(() {
                            _wordList;
                          });
                        },
                      )
                    : Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.pinkAccent,
                        hoverColor: Colors.purpleAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value) {
                          setState(
                            () {
                              deleteIndexList[index] = value!;
                              bool deleteProcessController = false;

                              deleteIndexList.forEach((element) {
                                if (element == true) {
                                  deleteProcessController = true;
                                }
                              });
                              if (!deleteProcessController) {
                                pressController = false;
                              }
                            },
                          );
                        })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
