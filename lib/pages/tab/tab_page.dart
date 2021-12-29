import 'package:epayment_templete/models/todoModel.dart';
import 'package:epayment_templete/pages/home/home_page.dart';
import 'package:epayment_templete/pages/schedule/schedule_page.dart';
import 'package:epayment_templete/utils/DB.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import '../../generated/locale_keys.g.dart';
import '../rigister/rigister_page.dart';
import 'package:sqflite/sqflite.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

BuildContext _bc;

List<TabsInfo> tabInfo = [
  TabsInfo(
      imagePath: 'assets/tab/Onboarding-01.png',
      text1: LocaleKeys.intro_title1.tr(),
      text2: 'Lorem Ipsum',
      skipButton: LocaleKeys.intro_skip.tr(),
      nextButton: LocaleKeys.intro_next.tr()),
  TabsInfo(
      imagePath: 'assets/tab/Onboarding-02.png',
      text1: LocaleKeys.intro_title2.tr(),
      text2: 'Lorem Ipsum',
      skipButton: LocaleKeys.intro_prev.tr(),
      nextButton: LocaleKeys.intro_next.tr()),
  TabsInfo(
      imagePath: 'assets/tab/Onboarding-03.png',
      text1: LocaleKeys.intro_title3.tr(),
      text2: 'Lorem Ipsum',
      skipButton: '',
      nextButton: LocaleKeys.intro_signup.tr())
];
List<String> images = [
  "assets/tab/Onboarding-01.png",
  "assets/tab/Onboarding-02.png",
  "assets/tab/Onboarding-03.png"
];

List<String> text0 = ["春归何处。寂寞无行路", "春无踪迹谁知。除非问取黄鹂", "山色江声相与清，卷帘待得月华生"];
List<String> text1 = ["若有人知春去处。唤取归来同住", "百啭无人能解，因风飞过蔷薇", "可怜一曲并船笛，说尽故人离别情。"];

class _TabPageState extends State<TabPage> {
  sql() async {
    var db = await openDatabase('my_db.db');
    Database database = await openDatabase(db.path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
    });
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
      print('inserted1: $id1');
      int id2 = await txn.rawInsert(
          'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });

    List<Map> list = await database.rawQuery('SELECT * FROM Test');
    List<Map> expectedList = [
      {'name': 'updated name', 'id': 1, 'value': 9876, 'num': 456.789},
      {'name': 'another name', 'id': 2, 'value': 12345678, 'num': 3.1416}
    ];
    print(list);
    print(expectedList);
  }

  final _controller = new IndexController();

  int _index = 0;
  //

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _bc = context;
    });

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(children: <Widget>[
      TransformerPageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              _index = index;
            });
          },
          loop: false,
          viewportFraction: 0.8,
          transformer: new PageTransformerBuilder(
              builder: (Widget child, TransformInfo info) {
            return new Container(
              padding: EdgeInsets.all(30),
              width: 100,
              height: 100,
              color: Colors.white,
              child: new Image.asset(
                images[info.index],
                //position: info.position,
              ),
            );
          }),
          itemCount: 3),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 170,
          child: Text(
            tabInfo[_index].text1,
            style: TextStyle(fontSize: 26, color: Colors.black),
            textAlign: TextAlign.center,
          )),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 140,
          child: Text(
            tabInfo[_index].text2,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          )),
      Positioned(
        left: 0.0,
        bottom: 10.0,
        child: FlatButton(
            onPressed: () async {
              if (Localizations.localeOf(context).languageCode == "en") {
                switch (tabInfo[_index].skipButton) {
                  case 'Skip':
                    await _controller.move(tabInfo.length - 1);
                    break;
                  case 'Previous':
                    await _controller.move(0);
                    break;
                }
              } else if (Localizations.localeOf(context).languageCode == "ar") {
                switch (tabInfo[_index].skipButton) {
                  case 'تخطي':
                    await _controller.move(tabInfo.length - 1);
                    break;
                  case 'السابق':
                    await _controller.move(0);
                    break;
                }
              }
            },
            child: Text(
              tabInfo[_index].skipButton,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            )),
      ),
      Positioned(
        right: 0.0,
        bottom: 10.0,
        child: FlatButton(
            onPressed: () async {
              if (Localizations.localeOf(context).languageCode == "en") {
                switch (tabInfo[_index].nextButton) {
                  case 'Next':
                    await _controller.move(_index + 1);
                    break;
                  case 'Signup':
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RigisterPage()));
                    break;
                }
              } else if (Localizations.localeOf(context).languageCode == "ar") {
                switch (tabInfo[_index].nextButton) {
                  case 'التالي':
                    await _controller.move(_index + 1);
                    break;
                  case 'تسجيل':
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => RigisterPage()));
                    break;
                }
              }
            },
            child: Text(tabInfo[_index].nextButton,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black))),
      )
    ]));
  }

  String _task = "new task";

  List<TodoItem> _tasks = [];

  void _save() async {
    Navigator.of(context).pop();
    TodoItem item = TodoItem(task: _task, complete: 1);

    await DB.insert(TodoItem.table, item);
    //setState(() => _task = '' );
    refresh();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(TodoItem.table);
    _tasks = _results.map((item) => TodoItem.fromMap(item)).toList();
    print(_tasks);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }
}

class TabsInfo {
  String imagePath;
  String text1;
  String text2;
  String skipButton;
  String nextButton;
  TabsInfo(
      {this.imagePath,
      this.text1,
      this.text2,
      this.nextButton,
      this.skipButton});
}
