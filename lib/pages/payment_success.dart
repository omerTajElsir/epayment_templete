import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../generated/locale_keys.g.dart';

class PaymentSuccess extends StatefulWidget {
  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffECA432),
        elevation: 0,
      ),
      backgroundColor: Color(0xffECA432),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: height * 5),
                child: Column(
                  children: <Widget>[
                    Text(
                      LocaleKeys.PaymentSuccess_subtitle,
                      style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ).tr(),
                    Text(
                      LocaleKeys.PaymentSuccess_title,
                      style: TextStyle(
                          color: Colors.grey[100],
                          fontSize: 27,
                          fontWeight: FontWeight.w900),
                    ).tr(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  height: height * 80,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: height * 25),
                  child: Stack(
                    children: <Widget>[
                      Container(
                          height: height * 60,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            'assets/CardBox.png',
                            fit: BoxFit.cover,
                          )),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: height * 11),
                          child: Column(
                            children: <Widget>[
                              Text(
                                LocaleKeys.PaymentSuccess_top_up_no,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ).tr(),
                              SizedBox(
                                height: height * 1.2,
                              ),
                              Center(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '4235',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '4235',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '4235',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '4235',
                                        style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 3,
                              ),
                              Container(
                                width: width * 63,
                                child: Image.asset('assets/dividerCard.png'),
                              ),
                              Container(
                                height: height * 27.7,
                                width: width * 72.7,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 6,
                                                  top: height * 4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    LocaleKeys
                                                        .PaymentSuccess_date,
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ).tr(),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    '3-2-2020',
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    LocaleKeys
                                                        .PaymentSuccess_phone,
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ).tr(),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    '0927521696',
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 3,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 6,
                                                    top: height * 1),
                                                child: Text(
                                                  LocaleKeys
                                                      .PaymentSuccess_top_up_amount,
                                                  style: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18),
                                                ).tr()),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 5,
                                                  top: height * 4),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    LocaleKeys
                                                        .PaymentSuccess_time,
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ).tr(),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    '10:00:00',
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    LocaleKeys
                                                        .PaymentSuccess_card_no,
                                                    style: TextStyle(
                                                        color: Colors.grey[500],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16),
                                                  ).tr(),
                                                  SizedBox(
                                                    height: height * 1,
                                                  ),
                                                  Text(
                                                    '234321234567',
                                                    style: TextStyle(
                                                        color: Colors.grey[700],
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 2,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: width * 4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Divider(
                                                        color:
                                                            Color(0x99979797),
                                                        thickness: 1,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height * 1,
                                                    ),
                                                    Container(
                                                        //margin: EdgeInsets.only(right: width * 5),
                                                        child: Text(
                                                      '200 SDG',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[500],
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 23),
                                                    )),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 75,
                width: 75,
                margin: EdgeInsets.only(top: height * 24),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffECA432),
                    border: Border.all(color: Colors.grey[100], width: 4)),
                child: Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
