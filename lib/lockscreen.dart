import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

import 'bottomsheets/bottomsheets.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var data = EasyLocalizationProvider.of(context).data;

    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
    );
    return ResponsiveWidgets.builder(
      child: Scaffold(
          backgroundColor: Color(0xffDBA14F),
          body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsetsResponsive.only(
                        top: 20.0, right: 20, left: 20),
                    child: GestureDetector(
                      onTap: () {
                        bottomSheetFailed(context);
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                          // alignment: Alignment.topRight,
                          children: <Widget>[
                            Text(
                              "next",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ]),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 47,
                          width: MediaQuery.of(context).size.width / 1.2,
                          // margin: EdgeInsets.fromLTRB(28.0, 0, 0, 0),
                          child: Material(
                            elevation: 6.0,
                            shadowColor: Colors.black38,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value.length > 3) {
                                  AppLock.of(context).didUnlock();
                                }
                              },
                              textAlign: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? TextAlign.center
                                  : TextAlign.center,
                              autofocus: false,
                              controller: _textEditingController,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.0)),
                                fillColor: Color(0xffDBA14F),
                                filled: true,
                                // labelText: 'Enter your number',
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: ("Passcode"),
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
                        Padding(
                          padding: EdgeInsetsResponsive.only(
                            top: 20.0,
                          ),
                          child: Align(
                            child: Text(
                              "Passcode must 4 digits",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container()
                ]),
          )),
    );
  }
}
