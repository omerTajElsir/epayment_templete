import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  var decoration = BoxDecoration(
      color: Color(0xffffd3d3), borderRadius: BorderRadius.circular(10));

  var selected = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 3),
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.grey[800],
                                ),
                                onPressed: null)),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              LocaleKeys.Transactions_Transactions,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ).tr())
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 3),
                      child: IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 25,
                            color: Colors.grey[800],
                          ),
                          onPressed: null)),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          LocaleKeys.Transactions_Your_wallet,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 22,
                              fontWeight: FontWeight.w900),
                        ).tr(),
                        Text(
                          'R20Y723',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              '284.12',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900),
                            ),
                            Text(
                              LocaleKeys.Transactions_SDG,
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ).tr(),
                          ],
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            width: 30,
                            height: 30,
                            child: Container(
                                margin: EdgeInsets.only(top: 2),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 30,
                                  color: Colors.grey[500],
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 8, bottom: 8),
                      decoration: selected == 1 ? decoration : null,
                      child: Center(
                          child: Text(
                        LocaleKeys.Transactions_Day,
                        style: TextStyle(
                            color: selected == 1
                                ? Color(0xffDBA14F)
                                : Colors.grey[800],
                            fontSize: selected == 1 ? 18 : 15,
                            fontWeight: FontWeight.w700),
                      ).tr()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 8, bottom: 8),
                      decoration: selected == 2 ? decoration : null,
                      child: Center(
                          child: Text(
                        LocaleKeys.Transactions_Week,
                        style: TextStyle(
                            color: selected == 2
                                ? Color(0xffDBA14F)
                                : Colors.grey[800],
                            fontSize: selected == 2 ? 18 : 15,
                            fontWeight: FontWeight.w700),
                      ).tr()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 3;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 8, bottom: 8),
                      decoration: selected == 3 ? decoration : null,
                      child: Center(
                          child: Text(
                        LocaleKeys.Transactions_Month,
                        style: TextStyle(
                            color: selected == 3
                                ? Color(0xffDBA14F)
                                : Colors.grey[800],
                            fontSize: selected == 3 ? 18 : 15,
                            fontWeight: FontWeight.w700),
                      ).tr()),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = 4;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 8, bottom: 8),
                      decoration: selected == 4 ? decoration : null,
                      child: Center(
                          child: Text(
                        LocaleKeys.Transactions_Year,
                        style: TextStyle(
                            color: selected == 4
                                ? Color(0xffDBA14F)
                                : Colors.grey[800],
                            fontSize: selected == 4 ? 18 : 15,
                            fontWeight: FontWeight.w700),
                      ).tr()),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Card(
              elevation: 5,
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Text(
                                '10, Sat',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              )),
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                'Feb 2020',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[600]),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffF9F9F9), width: 3))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 5,
                                  color: Color(0xffE0647B),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'POS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '21:15',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                ' + ' + '123 .SDG',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xff2BCB7D),
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffF9F9F9), width: 3))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 5,
                                  color: Color(0xffF6C186),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'POS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '21:15',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                ' - ' + '12.42 .SDG',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffEE5A55),
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 5),
//                        decoration: BoxDecoration(
//                            border: Border(
//                                bottom: BorderSide(
//                                    color: Color(0xffF9F9F9),
//                                    width: 3
//                                )
//                            )
//                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            margin:
                                EdgeInsets.only(left: 10, top: 5, bottom: 5),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 5,
                                  color: Color(0xffE98A80),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'POS',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  '21:15',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Text(
                                ' - ' + '18.22 .SDG',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffEE5A55),
                                    fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
