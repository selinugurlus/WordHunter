import 'package:flutter/material.dart';
import 'package:kelimeezberle/db/db/db.dart';
import 'package:kelimeezberle/pages/create_list.dart';
import 'package:kelimeezberle/pages/words.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  List<Map<String, Object?>> _lists = [];

  bool pressController = false;
  List<bool> deleteIndexList = [];

  @override
  void initState() {
    super.initState();
    getLists();
  }

  void getLists() async {
    _lists = await DB.instance.getListAll();
    for (int i = 0; i < _lists.length; ++i) {
      deleteIndexList.add(false);
    }
    setState(() {
      _lists;
    });
  }

  void delete() async {
    List<int> removeIndexList = [];

    for (int i = 0; i < _lists.length; ++i) {
      if (deleteIndexList[i] == true) {
        removeIndexList.add(i);
      }

      for (int i = removeIndexList.length - 1; i >= 0; --i) {
        DB.instance.deleteListsAndWordByList(
            _lists[removeIndexList[i]]['list_id'] as int);
        _lists.removeAt(removeIndexList[i]);
        deleteIndexList.removeAt(removeIndexList[i]);
      }
    }
    for (int i = 0; i < deleteIndexList.length; ++i) {
      deleteIndexList[i] = false;
    }
    setState(() {
      _lists;
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
              child: Image.asset(
                "assets/images/lists.png",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateList()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) {
            return listItem(_lists[index]['list_id'] as int, index,
                listName: _lists[index]['name'].toString(),
                sumWords: _lists[index]['sum_word'].toString(),
                sumUnlearned: _lists[index]['sum_unlearned'].toString());
          },
          itemCount: _lists.length,
        ),
      ),
    );
  }

  InkWell listItem(int id, int index,
      {@required String? listName,
      @required String? sumWords,
      @required String? sumUnlearned}) {
    return InkWell(
      onTap: () {
        debugPrint(id.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WordsPage(id, listName))).then((value) {
          getLists();
        });
      },
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
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Text(listName!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "RobotoMedium")),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text("Toplam " + sumWords! + " terim",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: "RobotoRegular")),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30),
                      child: Text(
                          (int.parse(sumWords) - int.parse(sumUnlearned!))
                                  .toString() +
                              " öğrenildi",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: "RobotoRegular")),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 30, bottom: 5),
                      child: Text(sumUnlearned + " öğrenilmedi",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: "RobotoRegular")),
                    )
                  ],
                ),
                pressController == true
                    ? Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.purpleAccent,
                        hoverColor: Colors.pinkAccent,
                        value: deleteIndexList[index],
                        onChanged: (bool? value) {
                          setState(() {
                            deleteIndexList[index] = value!;

                            bool deleteProcessController = false;

                            deleteIndexList.forEach((element) {
                              if (element == true)
                                deleteProcessController = true;
                            });
                            if (!deleteProcessController)
                              pressController = false;
                          });
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
