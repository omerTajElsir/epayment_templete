import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:math' as math;

import '../../generated/locale_keys.g.dart';
// import '../../consts.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.Profile_profile),
        backgroundColor: Color(0xff161616),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: width * 100,
              height: height * 100,
              child: ListView(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        color: Color(0xff161616),
                        height: height * 20,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                            margin: EdgeInsets.only(top: height * 2),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 7,
                            child: Container(
                              width: width * 83,
                              height: height * 26,
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: height * 0,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 90,
                                        height: 100,
                                        color: Colors.blueGrey,
//                                  child: Image.asset(''),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 2,
                                    ),
                                    Text(
                                      'Ahmed ALbasha',
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: height * .5,
                                    ),
                                    Text(
                                      '+' + '249927521696',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 2,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:
                            EdgeInsets.only(left: width * 8, right: width * 8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              LocaleKeys.Profile_GENERAL,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ).tr()),
                      ),
                    ],
                  ),
                  Card(
                      margin: EdgeInsets.only(top: height * 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      child: Container(
                        width: width * 90,
                        height: height * 9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 3,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 50,
                                    height: height * 7,
                                    color: Color(0xffDEDFE1),
                                    child: Center(
                                      child: Icon(
                                        Icons.settings,
                                        size: 23,
                                        color: Colors.grey[600],
                                      ),
                                    ),
//                                  child: Image.asset(''),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.Profile_Account_Settings,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ).tr(),
                                    SizedBox(
                                      height: height * 1,
                                    ),
                                    Text(
                                      LocaleKeys
                                          .Profile_Update_and_modify_your_profile,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ).tr(),
                                  ],
                                )
                              ],
                            ),
                            Localizations.localeOf(context).languageCode == "en"
                                ? Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 35,
                                    color: Colors.grey[400],
                                  )
                                : Container(
                                    child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 35,
                                          color: Colors.grey[400],
                                        )),
                                  )
                          ],
                        ),
                      )),
                  Card(
                      margin: EdgeInsets.only(top: height * 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      child: Container(
                        width: width * 90,
                        height: height * 9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 3,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 50,
                                    height: height * 7,
                                    color: Color(0xffDEDFE1),
                                    child: Center(
                                      child: Icon(
                                        Icons.credit_card,
                                        size: 23,
                                        color: Colors.grey[600],
                                      ),
                                    ),
//                                  child: Image.asset(''),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.Profile_Payment_Details,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ).tr(),
                                    SizedBox(
                                      height: height * 1,
                                    ),
                                    Text(
                                      LocaleKeys.Profile_Cards_Settings,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ).tr(),
                                  ],
                                )
                              ],
                            ),
                            Localizations.localeOf(context).languageCode == "en"
                                ? Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 35,
                                    color: Colors.grey[400],
                                  )
                                : Container(
                                    child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 35,
                                          color: Colors.grey[400],
                                        )),
                                  )
                          ],
                        ),
                      )),
                  Card(
                      margin: EdgeInsets.only(top: height * 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      child: Container(
                        width: width * 90,
                        height: height * 9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 3,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 50,
                                    height: height * 7,
                                    color: Color(0xffDEDFE1),
                                    child: Center(
                                      child: Icon(
                                        Icons.notifications,
                                        size: 25,
                                        color: Colors.grey[600],
                                      ),
                                    ),
//                                  child: Image.asset(''),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.Profile_App_Settings,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ).tr(),
                                    SizedBox(
                                      height: height * 1,
                                    ),
                                    Text(
                                      LocaleKeys.Profile_Notifications_Alerts,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ).tr(),
                                  ],
                                )
                              ],
                            ),
                            Localizations.localeOf(context).languageCode == "en"
                                ? Icon(
                                    Icons.keyboard_arrow_right,
                                    size: 35,
                                    color: Colors.grey[400],
                                  )
                                : Container(
                                    child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: Icon(
                                          Icons.keyboard_arrow_right,
                                          size: 35,
                                          color: Colors.grey[400],
                                        )),
                                  )
                          ],
                        ),
                      )),
                  Card(
                      margin: EdgeInsets.only(
                          bottom: height * 2.5, top: height * 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 7,
                      child: Container(
                        width: width * 90,
                        height: height * 9,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: width * 3,
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: 50,
                                    height: height * 7,
                                    color: Color(0xffffd3d3),
                                    child: Container(
                                        margin: EdgeInsets.only(right: 2),
                                        child: Icon(
                                          Icons.arrow_back_ios,
                                          size: 25,
                                          color: Colors.grey[600],
                                        )),
//                                  child: Image.asset(''),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 3,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.Profile_Logout,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ).tr(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
