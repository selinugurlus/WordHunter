import 'package:kelimeezberle/db/models/lists.dart';
import 'package:kelimeezberle/db/models/words.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static final DB instance = DB._init();
  static Database? _database;

  DB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('wordhunter.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType =
        'INTEGER PRIMARY KEY AUTOINCREMENT'; //İDLER KENDİ KENDİNE ARTCAK
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNameLists(
    ${ListsTableFields.id} $idType,
    ${ListsTableFields.name} $textType
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tableNameWords(
    ${WordTableFields.id}  $idType,
    ${WordTableFields.list_id}  $integerType,
    ${WordTableFields.word_eng}  $textType,
    ${WordTableFields.word_tr}  $textType,
    ${WordTableFields.status}  $boolType,
    FOREIGN KEY(${WordTableFields.list_id}) REFERENCES $tableNameLists (${ListsTableFields.id}))
    ''');
  }

  Future<Lists> insertList(Lists lists) async //liste oluşturma metodu
  {
    final db = await instance.database;
    final id = await db.insert(tableNameLists, lists.toJson());

    return lists.copy(id: id);
  }

  Future<Word> insertWord(Word word) async //kelime ekleme metodu
  {
    final db = await instance.database;
    final id = await db.insert(tableNameWords, word.toJson());

    return word.copy(id: id);
  }

  Future<List<Word>> getWordByList(
      int? listID) async //listenin id'sine göre kelime listesi getirme metodu
  {
    final db = await instance.database;
    final orderBy = '${WordTableFields.id} ASC';
    final result = await db.query(tableNameWords,
        orderBy: orderBy,
        where: '${WordTableFields.list_id} = ?',
        whereArgs: [listID]);

    return result.map((json) => Word.fromJson(json)).toList();
  }

  Future<List<Map<String, Object?>>>
      getListAll() async //Tüm listeleri getirme metodu
  {
    final db = await instance.database;
    //final orderBy = '${ListsTableFields.id} ASC';
    //final result = await db.query(tableNameLists, orderBy: orderBy);
    //return result.map((json) => Lists.fromJson(json)).toList();

    List<Map<String, Object?>> res = [];
    List<Map<String, Object?>> lists =
        await db.rawQuery("SELECT id,name FROM lists");

    await Future.forEach(lists, (element) async {
      element as Map;

      var wordInfoByList = await db.rawQuery(
          "SELECT(SELECT COUNT(*) FROM words where list_id= ${element['id']}) as sum_word,"
          "(SELECT COUNT(*) FROM words where status=0 and list_id=${element['id']}) as sum_unlearned");

      Map<String, Object?> temp = Map.of(wordInfoByList[0]);
      temp["name"] = element["name"];
      temp["list_id"] = element["id"];
      res.add(temp);
    });

    print(res);
    return res;
    //return result.map((json) => Lists.fromJson(json)).toList();
  }

  Future<List<Word>> getWordByLists(List<int> listsID,
      {bool? status}) async //Tüm listeleri getirme metodu
  {
    final db = await instance.database;

    String idList = "";
    for (int i = 0; i < listsID.length; ++i) {
      if (i == listsID.length - 1) {
        idList += (listsID[i].toString());
      } else {
        idList += (listsID[i].toString() + ",");
      }
    }

    List<Map<String, Object?>> result;

    if (status != null) {
      result = await db.rawQuery('SELECT * FROM words WHERE list_id IN(' +
          idList +
          ') and status=' +
          (status ? "1" : "0") +
          '');
    } else {
      result = await db
          .rawQuery('SELECT * FROM words WHERE list_id IN(' + idList + ')');
    }

    return result.map((json) => Word.fromJson(json)).toList();
    //return result.map((json) => Lists.fromJson(json)).toList();
  }

  Future<int> updateWord(Word word) async //kelime güncelleme metodu
  {
    final db = await instance.database;
    return db.update(tableNameWords, word.toJson(),
        where: '${WordTableFields.id} = ?', whereArgs: [word.id]);
  }

  Future<int> updateList(Lists lists) async //listenin adı güncelleme metodu
  {
    final db = await instance.database;
    return db.update(tableNameLists, lists.toJson(),
        where: '${ListsTableFields.id} = ?', whereArgs: [lists.id]);
  }

  Future<int> deleteWord(int id) async //kelime silme metodu
  {
    final db = await instance.database;
    return db.delete(tableNameWords,
        where: '${WordTableFields.id} = ?', whereArgs: [id]);
  }

  Future<int> markAsLearned(bool mark, int id) async {
    final db = await instance.database;
    int result = mark == true ? 1 : 0;
    return db.update(tableNameWords, {WordTableFields.status: result},
        where: '${WordTableFields.id}=?', whereArgs: [id]);
  }

  Future<int> deleteListsAndWordByList(int id) async //kelime silme metodu
  {
    final db = await instance.database;

    int result = await db.delete(tableNameLists,
        where: '${ListsTableFields.id} = ?', whereArgs: [id]);
    if (result == 1) {
      await db.delete(tableNameWords,
          where: '${WordTableFields.list_id}=?', whereArgs: [id]);
    }
    return result;
  }

  Future close() async //bağlantıyı kapat
  {
    final db = await instance.database;
    db.close();
  }
}
