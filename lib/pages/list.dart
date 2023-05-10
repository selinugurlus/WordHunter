import 'package:flutter/material.dart';
import 'package:kelimeezberle/pages/create_list.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({Key? key}) : super(key: key);

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreateList()));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                child: Card(
                  color: Colors.white70,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 5),
                        child: Text("Liste Adı",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "RobotoMedium")),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Text("305 terim",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "RobotoRegular")),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        child: Text("5 öğrenildi",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "RobotoRegular")),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, bottom: 5),
                        child: Text("6 öğrenilmedi",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: "RobotoRegular")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
