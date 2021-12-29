import 'package:epayment_templete/generated/locale_keys.g.dart';
import 'package:epayment_templete/pages/payment_success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopUp extends StatefulWidget {
  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> {
  double mtnM = 1.0, canarM = 15.0, zainM = 15.0, sudM = 15.0;
  Color mtnC = Colors.transparent,
      canarC = Colors.black54,
      zainC = Colors.black54,
      sudC = Colors.black54;
  final _phoneNumber = TextEditingController();
  final _amount = TextEditingController();
  final _topUpForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _topUpForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    size: 30,
                                    color: Colors.grey[800],
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })),
                          Container(
                              child: Text(
                            LocaleKeys.TopUp_title,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ))
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
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 30),
                child: Text(
                  LocaleKeys.TopUp_select_operator,
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ).tr(),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            mtnC = Colors.transparent;
                            zainC = Colors.black54;
                            canarC = Colors.black54;
                            sudC = Colors.black54;

                            mtnM = 1;
                            zainM = 15;
                            canarM = 15;
                            sudM = 15;
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(mtnM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffFFDB1C),
                                //color: mtnC,
                              ),
                              child: Center(
                                child: Image.asset('assets/mtn.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(mtnM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: mtnC,
                                //color: mtnC,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            mtnC = Colors.black54;
                            zainC = Colors.black54;
                            canarC = Colors.transparent;
                            sudC = Colors.black54;

                            mtnM = 15;
                            zainM = 15;
                            canarM = 1;
                            sudM = 15;
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(canarM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF26532),
                                //color: canarC,
                              ),
                              child: Center(
                                child: Image.asset('assets/canar.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(canarM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: canarC,
                                //color: mtnC,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            mtnC = Colors.black54;
                            zainC = Colors.transparent;
                            canarC = Colors.black54;
                            sudC = Colors.black54;

                            mtnM = 15;
                            zainM = 1;
                            canarM = 15;
                            sudM = 15;
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(zainM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff000207),
                                //color: zainC,
                              ),
                              child: Center(
                                child: Image.asset('assets/zain.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(zainM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: zainC,
                                //color: mtnC,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            mtnC = Colors.black54;
                            zainC = Colors.black54;
                            canarC = Colors.black54;
                            sudC = Colors.transparent;

                            mtnM = 15;
                            zainM = 15;
                            canarM = 15;
                            sudM = 1;
                          });
                        },
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.all(sudM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff0074C8),
                                //color: sudC,
                              ),
                              child: Center(
                                child: Image.asset('assets/sudani.png'),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(sudM),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: sudC,
                                //color: mtnC,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 30),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: LocaleKeys.TopUp_phone,
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      prefixText: '+249 ',
                      prefixStyle: TextStyle(fontSize: 14)),
                  style: TextStyle(fontSize: 14),
                  cursorColor: Colors.grey[700],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please fill this field';
                    } else if (value.length != 9) {
                      return 'phone must be 9 digits';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                margin: EdgeInsets.only(left: 25, right: 30),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: LocaleKeys.TopUp_amount.tr(),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 2.0),
                    ),
                  ),
                  style: TextStyle(fontSize: 14),
                  cursorColor: Colors.grey[700],
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'please fill this field';
                    }
                  },
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (_topUpForm.currentState.validate()) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentSuccess()));
                  }
                },
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff161616),
                        borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Center(
                      child: Text(
                        LocaleKeys.TopUp_pay,
                        style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
