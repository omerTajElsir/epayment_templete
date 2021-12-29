import 'package:epayment_templete/pages/home/home_page.dart';
import 'package:epayment_templete/pages/statistics/StatisticsPage.dart';
import 'package:epayment_templete/pages/tab/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/locale_keys.g.dart';
import '../transactions.dart';
import 'confirm_page.dart';

class RigisterPage extends StatefulWidget {
  @override
  _RigisterPageState createState() => _RigisterPageState();
}

class _RigisterPageState extends State<RigisterPage> {
  get sizebox => SizedBox(
        height: 40,
      );
  final _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _phoneNumber = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
              // alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 20, right: 3),
              width: size.width,
              height: size.height / 1.8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login/Login.gif'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 60,
                      child: FlatButton(
                        child: Text("EN"),
                        color:
                            Localizations.localeOf(context).languageCode == "en"
                                ? Colors.blue
                                : Colors.black12,
                        onPressed: () async {
                          await context.setLocale(context.supportedLocales[0]);
                        },
                      ),
                    ),
                    Container(
                      width: 70,
                      child: FlatButton(
                        child: Text("عربي"),
                        color:
                            Localizations.localeOf(context).languageCode == "ar"
                                ? Colors.blue
                                : Colors.black12,
                        onPressed: () async {
                          await context.setLocale(context.supportedLocales[1]);
                        },
                      ),
                    )
                  ],
                ),
              )),

          Form(
            key: _loginForm,
            child: Container(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        LocaleKeys.RigisterPage_Welcome_to,
                        style: TextStyle(fontSize: 20),
                      ).tr(),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        LocaleKeys.RigisterPage_TITLE,
                        style:
                            TextStyle(color: Color(0xffDBA14F), fontSize: 20),
                      ).tr()
                    ],
                  ),
                  sizebox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '+249',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(width: 28),
                      Container(
                        height: 47,
                        width: MediaQuery.of(context).size.width / 1.8,
                        // margin: EdgeInsets.fromLTRB(28.0, 0, 0, 0),
                        child: Material(
                          elevation: 6.0,
                          shadowColor: Colors.black38,
                          child: TextFormField(
                            textAlign:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? TextAlign.left
                                    : TextAlign.right,
                            autofocus: false,
                            controller: _phoneNumber,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0)),
                              fillColor: Colors.white,
                              filled: true,
                              // labelText: 'Enter your number',
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText:
                                  (LocaleKeys.RigisterPage_Enter_your_number)
                                      .tr(),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              ///add validation here

                              /*if (value.isEmpty) {
                                  return 'please fill this field';
                                }else if(value.length != 9){
                                  return 'phone must be 9 digits';
                                }*/
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  sizebox,
                  ButtonTheme(
                    minWidth: size.width,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () {
                        if (_loginForm.currentState.validate()) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ConfirmPage(
                                    phoneNumber: _phoneNumber.text,
                                  )));
                        }
                      },
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => StatisticsPage())),
                      child: Text(
                        LocaleKeys.RigisterPage_Login,
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                      color: Colors.black,
                    ),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomePage()));
                            },
                            child: Row(
                              children: <Widget>[
                                Text(LocaleKeys.RigisterPage_Our).tr(),
                                SizedBox(width: 7),
                                Text(
                                  LocaleKeys.RigisterPage_TC,
                                  style: TextStyle(color: Color(0xffDBA14F)),
                                ).tr(),
                              ],
                            )),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          )
          // sizebox,
        ]),
      ),
    );
  }
}
