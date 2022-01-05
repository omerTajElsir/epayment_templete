import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speedometer/linepainter.dart';
import 'package:rxdart/rxdart.dart';

class SpeedOMeter extends StatefulWidget {
  int start;
  int end;
  double highlightEnd;
  int index;

  PublishSubject<double> eventObservable;
  SpeedOMeter(
      {this.start,
      this.end,
      this.highlightEnd,
      this.eventObservable,
      this.index});

  @override
  _SpeedOMeterState createState() => new _SpeedOMeterState(
      this.start, this.end, this.highlightEnd, this.eventObservable);
}

class _SpeedOMeterState extends State<SpeedOMeter>
    with TickerProviderStateMixin {
  int start;
  int end;
  double highlightEnd;
  PublishSubject<double> eventObservable;

  double val = 0.0;
  double newVal;
  double textVal = 0.0;
  AnimationController percentageAnimationController;
  StreamSubscription<double> subscription;

  _SpeedOMeterState(int start, int end, double highlightEnd,
      PublishSubject<double> eventObservable) {
    this.start = start;
    this.end = end;
    // this.highlightStart = highlightStart;
    this.highlightEnd = highlightEnd;
    this.eventObservable = eventObservable;

    percentageAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {
          val = lerpDouble(val, newVal, percentageAnimationController.value);
        });
      });
    subscription = this.eventObservable.listen((value) {
      textVal = value;
      (value >= this.end) ? reloadData(this.end.toDouble()) : reloadData(value);
    }); //(value) => reloadData(value));
  }

  reloadData(double value) {
    print(value);
    newVal = value;
    percentageAnimationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).isCurrent == false) {
      return Text("");
    }
    return new Center(
      child: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return new Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //color: Colors.black,

          child: new Stack(fit: StackFit.expand, children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 15),
              child: RichText(
                  text: TextSpan(
                      text: 'for ',
                      style: TextStyle(color: Color(0xff77869E), fontSize: 13),
                      children: <TextSpan>[
                    TextSpan(
                        text: 'Bank Albalad ',
                        style: TextStyle(
                            color: Color(0xff042C5C),
                            fontSize: 13,
                            fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Card')
                  ])),
            ),
            new Container(
              padding: EdgeInsets.only(top: 50),
              child: new CustomPaint(
                  foregroundPainter: new LinePainter(
                      lineColor: Color(0xff77869E),
                      completeColor: Color(0xffDBA14F),
                      startValue: this.start,
                      endValue: this.end,
                      startPercent: 0,
                      endPercent: this.widget.highlightEnd,
                      width: 10.0)),
            ),
            Positioned(left: 50, bottom: 30, child: Text('$start%')),
            Positioned(right: 50, bottom: 30, child: Text('$end%')),
            Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 5,
                      width: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.index == 0
                            ? Color(0xff212121)
                            : Color(0xffE6ECF0),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 5,
                      width: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.index == 1
                            ? Color(0xff212121)
                            : Color(0xffE6ECF0),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 5,
                      width: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: widget.index == 2
                            ? Color(0xff212121)
                            : Color(0xffE6ECF0),
                      ),
                    ),
                  ],
                )),
            // new Center(
            //   aspectRatio: 1.0,
            // child: new Container(
            //     height: constraints.maxWidth,
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(20.0),
            //     child: new Stack(fit: StackFit.expand, children: <Widget>[
            //       new CustomPaint(
            //         painter: new HandPainter(
            //             value: val,
            //             start: this.start,
            //             end: this.end,
            //             color: this.widget.themeData.accentColor),
            //       ),
            //     ]))
            // ),
            new Center(
              child: new Container(
                width: 100,
                height: 150,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,

                  // color: this.widget.themeData.backgroundColor,
                ),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/min-card.png'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text('Your Spent',
                          style: TextStyle(
                              color: Color(0xff77869E), fontSize: 13)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text('\$${6.390}',
                          style: TextStyle(
                              color: Color(0xff042C5C), fontSize: 30)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text('of \$${3.248}',
                          style: TextStyle(
                              color: Color(0xff77869E), fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
            // new CustomPaint(
            //     painter: new SpeedTextPainter(
            //         start: this.start, end: this.end, value: this.textVal)),
          ]),
        );
      }),
    );
  }
}
