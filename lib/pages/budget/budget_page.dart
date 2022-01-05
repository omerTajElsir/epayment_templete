import 'package:epayment_templete/pages/month_report.dart';
import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:rxdart/rxdart.dart';
import '../speed_meter_edit.dart';

class BudgetPage extends StatefulWidget {
  BudgetPage({Key key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  double _upperValue = 40.0;
  int start = 0;
  int end = 100;
  PublishSubject<double> eventObservable = new PublishSubject();

  Size size;
  List<bool> _isSelected = [true, false, false, false];

// Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Your Budgets',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.left,
            ),
            IconButton(
                icon: Image.asset(
                  'assets/menu-icon.png',
                  color: Colors.white,
                ),
                onPressed: () {})
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
    );
  }

  @override
  void initState() {
    super.initState();
    eventObservable.add(10);
    print(eventObservable.publishValue());
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: _getAppbar,
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: size.height * 0.40,
                        width: size.width,
                        //color: Colors.black,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/blackpg.png"),
                                fit: BoxFit.cover)),
                        padding: EdgeInsets.only(top: 40, left: 10),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Text(
                                'Your Budgets',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: size.height * 0.10,
                        //color: Color(0xff77869E),
                      ),
                    ],
                  ),
                  Container(
                      height: size.height * 0.40,
                      width: size.width,
                      margin: EdgeInsets.only(top: 100),
                      child: Card(
                        margin: EdgeInsets.all(20),
                        child: TransformerPageView(
                            // transformer: ,
                            itemBuilder: (context, index) {
                              return SpeedOMeter(
                                  index: index,
                                  start: start,
                                  end: end,
                                  highlightEnd: (_upperValue / end),
                                  eventObservable: this.eventObservable);
                            },
                            itemCount: 3),
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Transactions',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff042C5C))),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MonthReport()));
                        },
                        child: Text('View All',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xff77869E)))),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ToggleButtons(
                    onPressed: (index) {
                      setState(() {
                        for (var i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = false;
                        }
                        _isSelected[index] = true;
                      });
                    },
                    fillColor: Color(0xffF8ECDC),
                    selectedColor: Color(0xffDBA14F),
                    color: Color(0xffDBA14F),
                    renderBorder: false,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: (size.width - 20) / 4,
                          child: Text(
                            'Day',
                            textAlign: TextAlign.center,
                          )),
                      Container(
                          width: (size.width - 20) / 4,
                          child: Text('Week', textAlign: TextAlign.center)),
                      Container(
                          width: (size.width - 20) / 4,
                          child: Text('Month', textAlign: TextAlign.center)),
                      Container(
                          width: (size.width - 20) / 4,
                          child: Text('Year', textAlign: TextAlign.center))
                    ],
                    isSelected: _isSelected),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: size.height * 0.50,
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                width: size.width,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              '10, Sat',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff707070)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text('Expenses: 66.14',
                                style: TextStyle(
                                    fontSize: 13, color: Color(0xff707070))),
                          ),
                        ],
                      ),
                      Divider(),
                      ListTile(
                        leading: Image.asset('assets/coffe.png'),
                        title: Text('Coffee'),
                        trailing: Text('- 4.50'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(),
                      ),
                      ListTile(
                        leading: Image.asset('assets/food.png'),
                        title: Text('Food'),
                        trailing: Text('- 15.60'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(),
                      ),
                      ListTile(
                        leading: Image.asset('assets/power_bill.png'),
                        title: Text('Power bill'),
                        trailing: Text('- 35.70'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Divider(),
                      ),
                      ListTile(
                        leading: Image.asset('assets/veggies.png'),
                        title: Text('Veggies'),
                        trailing: Text('- 10.34'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
