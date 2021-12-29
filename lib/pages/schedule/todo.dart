import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../generated/locale_keys.g.dart';

class TodoTwoPage extends StatefulWidget {
  static final String path = "lib/src/pages/todo/todo2.dart";

  @override
  _TodoTwoPageState createState() => _TodoTwoPageState();
}

class _TodoTwoPageState extends State<TodoTwoPage> {
  int selected = 5;

  final TextStyle selectedText =
      TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14);

  final TextStyle selectedDay =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10);

  final TextStyle daysText = TextStyle(
      fontWeight: FontWeight.normal, color: Colors.grey.shade500, fontSize: 10);

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = [
      LocaleKeys.weeks_sun.tr(),
      LocaleKeys.weeks_mon.tr(),
      LocaleKeys.weeks_tue.tr(),
      LocaleKeys.weeks_wed.tr(),
      LocaleKeys.weeks_thu.tr(),
      LocaleKeys.weeks_fri.tr(),
      LocaleKeys.weeks_sat.tr(),
    ];
    final List<int> dates = [5, 6, 7, 8, 9, 10, 11];

    Widget noSchedule = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Text(
            LocaleKeys.todo_no_schedule,
            style: TextStyle(color: Colors.grey, fontSize: 18),
            textAlign: TextAlign.center,
          ).tr(),
          SizedBox(
            height: 30,
          ),
          Image.asset("assets/nosch.png"),
          SizedBox(
            height: 30,
          ),
          Text(
            LocaleKeys.todo_enjoy,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            textAlign: TextAlign.center,
          ).tr(),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );

    Widget schedule = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  height: 40,
                  color: Color(0xFF04A777),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.location_city,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Government fees",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  height: 40,
                  color: Colors.purpleAccent,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.card_membership,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Transportation",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                "9AM",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );

    Widget sch = noSchedule;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            LocaleKeys.todo_schedule,
            style: TextStyle(color: Colors.black),
          ).tr(),
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          centerTitle: false,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      LocaleKeys.months_jan.toUpperCase(),
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          letterSpacing: 2.0),
                    ).tr(),
                  ),
                  Row(
                    children: weekDays.map((w) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = weekDays.indexOf(w);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: weekDays.indexOf(w) == selected
                                    ? Colors.orange.shade100
                                    : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(30.0))),
                            padding:
                                const EdgeInsets.only(top: 20, bottom: 8.0),
                            child: Text(
                              w.toUpperCase(),
                              style: weekDays.indexOf(w) == selected
                                  ? selectedText
                                  : daysText,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: dates.map((d) {
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = dates.indexOf(d);
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: dates.indexOf(d) == selected
                                    ? Colors.orange.shade100
                                    : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(30.0))),
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 20.0),
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: dates.indexOf(d) == selected
                                  ? Colors.black
                                  : Colors.transparent,
                              child: Text("$d",
                                  style: dates.indexOf(d) == selected
                                      ? selectedDay
                                      : daysText),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            selected == 1 || selected == 4 ? schedule : noSchedule,
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.80,
                height: 50,
                child: RaisedButton(
                  onPressed: () {},
                  // onPressed: () =>
                  //     Navigator.of(context).push(MaterialPageRoute(
                  //         builder: (context) => ConfirmPage(
                  //               phoneNumber: _phoneNumber.text,
                  //             ))),
                  child: Text(
                    LocaleKeys.todo_add_expense,
                    style: TextStyle(color: Colors.white),
                  ).tr(),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
