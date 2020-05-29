import 'package:epayment_templete/pages/schedule/todo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class MonthReport extends StatefulWidget {
  @override
  _MonthReportState createState() => _MonthReportState();
}

class _MonthReportState extends State<MonthReport> {

  var width, height;
  int touchedIndex;
  var selected = 1;

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();



  @override
  Widget build(BuildContext context) {

    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;

    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Month Reposrt",style: TextStyle(color: Colors.black),),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[

              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 50,bottom: 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: AnimatedCircularChart(
                                key: _chartKey,
                                size: Size(150.0, 115.0),
                                initialChartData: <CircularStackEntry>[
                                  new CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      new CircularSegmentEntry(
                                        36.33,
                                        Color(0xff820263),
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        29.33,
                                        Color(0xffDFAA60),
                                        rankKey: 'remaining',
                                      ),
                                      new CircularSegmentEntry(
                                        12.33,
                                        Color(0xff820263),
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        30.33,
                                        Color(0xff4CD3B5),
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ],
                                chartType: CircularChartType.Radial,
                                percentageValues: true,
                                holeLabel: 'Expenses  \n2,432.11',
                                labelStyle: new TextStyle(
                                  color: Colors.blueGrey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 15,right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: Color(0xff04A777),width: 3)
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('Bills',style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right : 15),
                                            child: Text('32.2 %',style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: Color(0xff2A51BC),width: 3)
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('Exercise',style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right : 15),
                                            child: Text('20.1 %',style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: Color(0xffFDBA2D),width: 3)
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('Social',style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right : 15),
                                            child: Text('11.3 %',style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: Color(0xff820263),width: 3)
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('Transportation',style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right : 15),
                                            child: Text('8.2 %',style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 7,),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.white,
                                                    border: Border.all(color: Color(0xffD90368),width: 3)
                                                ),
                                              ),
                                              SizedBox(width: 5,),
                                              Text('Others',style: TextStyle(
                                                  color: Colors.grey[700],
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(right : 15),
                                            child: Text('27.3 %',style: TextStyle(
                                                color: Colors.grey[900],
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600
                                            ),),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 40,),
                      Card(
                        elevation: 8,
                        margin: EdgeInsets.only(left: 15,right: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                        ),
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
                                        margin:EdgeInsets.only(left: 10,right: 10),
                                        child: Text('Expenses',style: TextStyle(fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.w600),)
                                    ),
                                    Container(
                                        margin:EdgeInsets.only(right: 10,left: 10),
                                        child: Text('Total: 2,432.11',style: TextStyle(fontSize: 18,color: Colors.grey[600],fontWeight: FontWeight.w600),)
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xffE0647B),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.flash_on,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Bills',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('32.2%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('1,543.13',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.9,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xff3966CB),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.accessibility_new,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Exercise',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('20.1%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('500.00',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.5,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xffFDC233),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.battery_charging_full,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Social',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('11.3%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('287.32',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.4,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xff820263),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.battery_charging_full,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Transportation',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('8.2%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('206.92',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.3,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xff3966CB),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.battery_charging_full,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Food',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('7.2%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('166.85',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.3,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 60,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffF9F9F9),
                                            width: 3
                                        )
                                    )
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin:EdgeInsets.only(left: 10,top: 5,bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Color(0xffD90368),
                                                shape: BoxShape.circle
                                            ),
                                            child: Icon(Icons.battery_charging_full,size: 15,color: Colors.white,),
                                          ),
                                          SizedBox(width: 15,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: width * 70,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        Text('Insurance',style: TextStyle(fontSize: 18,color: Colors.grey[900],fontWeight: FontWeight.w600),),
                                                        SizedBox(width: 10,),
                                                        Text('5.5%',style: TextStyle(fontSize: 15,color: Colors.grey[500],fontWeight: FontWeight.w500),),
                                                      ],
                                                    ),
                                                    Text('140.20',style: TextStyle(fontSize: 18,color: Colors.grey[800],fontWeight: FontWeight.w600),),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                child: LinearPercentIndicator(
                                                  width: width * 70,
                                                  animation: true,
                                                  lineHeight: 5.0,
                                                  animationDuration: 2000,
                                                  percent: 0.4,
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Color(0xffF7C986),
                                                  backgroundColor: Colors.white,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 1,
                margin: EdgeInsets.all(0),
                child: Container(
                  color: Colors.white,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 10,),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'November',
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 3),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      size: 35,
                                      color: Colors.grey[800],
                                    ),
                                    onPressed: null)),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          child: IconButton(
                              icon: Icon(
                                Icons.calendar_today,
                                size: 23,
                                color: Colors.grey[700],
                              ),
                              onPressed: (){
                                /*showModalBottomSheet(
                                    context: (context),
                                    builder: (context) {
                                      return Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                  margin: const EdgeInsets.all(0),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        height:50,
                                                        decoration:BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20),
                                                            ),
                                                          border: Border.all(width: 1,color: Colors.grey[300]),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(child: Text(AppLocalizations.of(context).tr('MonthReport.receive'),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[800]),)),
                                                      ),

                                                      Container(
                                                        height:50,
                                                        decoration:BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            bottomLeft: Radius.circular(20),
                                                            bottomRight: Radius.circular(20),
                                                          ),
                                                          border: Border.all(width: 1,color: Colors.grey[300]),
                                                          color: Colors.white,
                                                        ),
                                                        child: Center(child: Text(AppLocalizations.of(context).tr('MonthReport.send'),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[800]),)),
                                                      ),
                                                    ],
                                                  )
                                              ),
                                              SizedBox(height: 5,),
                                              Container(
                                                height: 50,
                                                width: MediaQuery.of(context).size.width,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(AppLocalizations.of(context).tr('MonthReport.cancel'),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey[800]),),
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)));*/
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) => TodoTwoPage()));
                              }
                          )
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _cycleSamples() {
    List<CircularStackEntry> nextData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(1500.0, Colors.red[200], rankKey: 'Q1'),
          new CircularSegmentEntry(750.0, Colors.green[200], rankKey: 'Q2'),
          new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
          new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
        ],
        rankKey: 'Quarterly Profits',
      ),
    ];
    setState(() {
      _chartKey.currentState.updateData(nextData);
    });
  }

  List<CircularStackEntry> data = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(500.0, Colors.red[200], rankKey: 'Q1'),
        new CircularSegmentEntry(1000.0, Colors.green[200], rankKey: 'Q2'),
        new CircularSegmentEntry(2000.0, Colors.blue[200], rankKey: 'Q3'),
        new CircularSegmentEntry(1000.0, Colors.yellow[200], rankKey: 'Q4'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];
}
