import 'package:easy_localization/easy_localization.dart';
import 'package:epayment_templete/generated/locale_keys.g.dart';
import 'package:flutter/material.dart';

class Electricity extends StatefulWidget {
  @override
  _ElectricityState createState() => _ElectricityState();
}

class _ElectricityState extends State<Electricity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            margin: EdgeInsets.only(top: 3),
                            child: Text(
                              LocaleKeys.Electricity_title,
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
              height: 70,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        LocaleKeys.Electricity_new,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 100,
                    height: 40,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        LocaleKeys.Electricity_saved,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ).tr(),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 30),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: LocaleKeys.Electricity_meter_no.tr(),
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                style: TextStyle(fontSize: 14),
                cursorColor: Colors.grey[700],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              margin: EdgeInsets.only(left: 25, right: 30),
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: LocaleKeys.Electricity_amount.tr(),
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                  ),
                ),
                style: TextStyle(fontSize: 14),
                cursorColor: Colors.grey[700],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xff161616),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Text(
                    LocaleKeys.Electricity_pay,
                    style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ).tr(),
                )),
          ],
        ),
      ),
    );
  }
}
