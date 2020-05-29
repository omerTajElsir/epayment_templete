import 'package:epayment_templete/pages/electricity.dart';
import 'package:epayment_templete/pages/electricity/electricity_page.dart';
import 'package:epayment_templete/pages/top_up.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization_delegate.dart';
import 'package:epayment_templete/pages/electricity/electricity_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Bills extends StatefulWidget {
  @override
  _BillsState createState() => _BillsState();
}

class _BillsState extends State<Bills> {

  List<String> anims= ["Unfavorite","Unfavorite","Unfavorite","Unfavorite","Unfavorite","Unfavorite"];

  _billRow(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            elevation: 1,
            child: Container(
              height: 70,
              width: 70,
              child: Center(
                child: Image.asset('assets/haji.png'),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Haji',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                  SizedBox(height: 10,),
                  Text('Haji Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                ],
              )
          )
        ],
      ),
    );
  }

  void _likeAnimate(int i) {
    setState(() {
      if(anims[i] == "Favorite"){
        anims[i] = "Unfavorite";
      }else {
        anims[i] = "Favorite";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Scaffold(
        backgroundColor: Colors.white,
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
                                  onPressed: (){
                                    Navigator.pop(context);
                                  })),
                          Container(
                              child: Text(
                            AppLocalizations.of(context).tr('Bills.title'),
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
                  AppLocalizations.of(context).tr('Bills.available_bills'),
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Card(

                              elevation: 1,
                              child: Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(12),

                                child: Center(
                                  child: Image.asset('assets/haji.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Haji',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                      SizedBox(height: 10,),
                                      Text('Haji Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                    ],
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _likeAnimate(0);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FlareActor(
                                    "assets/like3.flr",
                                    animation:anims[0],
                                    fit: BoxFit.scaleDown,
                                    //color: Colors.red,

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              elevation: 1,
                              child: Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(12),

                                child: Center(
                                  child: Image.asset('assets/payee/homeG.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Home',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                      SizedBox(height: 10,),
                                      Text('Ministry of Education',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                    ],
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _likeAnimate(1);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FlareActor(
                                    "assets/like3.flr",
                                    animation:anims[1],
                                    fit: BoxFit.scaleDown,
                                    //color: Colors.red,

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              elevation: 1,
                              child: Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(12),

                                child: Center(
                                  child: Image.asset('assets/payee/tax.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Tax',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                      SizedBox(height: 10,),
                                      Text('Tax Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                    ],
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _likeAnimate(2);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FlareActor(
                                    "assets/like3.flr",
                                    animation:anims[2],
                                    fit: BoxFit.scaleDown,
                                    //color: Colors.red,

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              elevation: 1,
                              child: Container(
                                height: 70,
                                width: 70,
                                padding: EdgeInsets.all(12),

                                child: Center(
                                  child: Image.asset('assets/payee/e15G.png'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('E 15',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                      SizedBox(height: 10,),
                                      Text('Goverment Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                    ],
                                  )
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _likeAnimate(3);
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: FlareActor(
                                    "assets/like3.flr",
                                    animation:anims[3],
                                    fit: BoxFit.scaleDown,
                                    //color: Colors.red,

                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => ElectricityPage()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                elevation: 1,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: EdgeInsets.all(12),

                                  child: Center(
                                    child: Image.asset('assets/payee/elecG.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Electricity',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                        SizedBox(height: 10,),
                                        Text('Electricity Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  _likeAnimate(4);
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: FlareActor(
                                      "assets/like3.flr",
                                      animation:anims[4],
                                      fit: BoxFit.scaleDown,
                                      //color: Colors.red,

                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => TopUp()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20,bottom: 10,right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                elevation: 1,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  padding: EdgeInsets.all(12),
                                  child: Center(
                                    child: Image.asset('assets/payee/topupG.png'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Top Up',style: TextStyle(color: Colors.grey[900],fontSize: 18,fontWeight: FontWeight.w600),),
                                        SizedBox(height: 10,),
                                        Text('Top Up Services',style: TextStyle(color: Colors.grey[700],fontSize: 15,fontWeight: FontWeight.w500),),
                                      ],
                                    )
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  _likeAnimate(5);
                                },
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: FlareActor(
                                      "assets/like3.flr",
                                      animation:anims[5],
                                      fit: BoxFit.scaleDown,
                                      //color: Colors.red,

                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
