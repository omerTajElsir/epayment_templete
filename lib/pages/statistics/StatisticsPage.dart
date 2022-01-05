import 'package:epayment_templete/pages/budget/budget_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../generated/locale_keys.g.dart';
import '../home/home_page.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsPage extends StatefulWidget {
  StatisticsPage({Key key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

BuildContext _con;

class _StatisticsPageState extends State<StatisticsPage> {
  Size size;
  String incomeBalance = '3,214';
  String expenceBalance = '1,640';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
  }

  final List<Transaction> transaction = [
    Transaction('POS', '12:03:2018 21:15', 123.12, 'CR', 'SDG'),
    Transaction('Bank', '15.03.2018 15:00', 12.42, 'DR', 'SDG'),
    Transaction('POS', '15.03.2018 15:00', 18.22, 'DR', 'SDG'),
  ];
  // Returns "Appbar"
  get _getAppbar {
    print(size.height);
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              LocaleKeys.stat_statistics,
              style: TextStyle(color: Color(0xff323643), fontSize: 20),
            ).tr(),
          ],
        ),
      ),
      //leading: IconButton(icon: Image.asset('assets/menu-icon.png') , onPressed: (){}),
      centerTitle: false,
    );
  }

  get _listOfTransactions {
    return Card(
      child: ListView.builder(
          primary: false,
          itemCount: transaction.length,
          itemBuilder: (BuildContext context, int index) {
            String drcr = transaction[index].drcr;
            return ListTile(
              leading: Text(
                '${transaction[index].name}',
                style: TextStyle(fontSize: 15),
              ),
              title: Text(
                '(${transaction[index].time})',
                style: TextStyle(fontSize: 15),
              ),
              trailing: Text(
                '${drcr == 'CR' ? '+' : '-'} ${transaction[index].amount} .${transaction[index].curr}',
                style: TextStyle(
                    fontSize: 15,
                    color:
                        drcr == 'CR' ? Color(0xff1BC773) : Color(0xffEE5A55)),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _con = context;
    });

    return Scaffold(
      appBar: _getAppbar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ListView(
              primary: true,
              children: <Widget>[
                Container(
                  height: size.height * 0.10,
                  child: IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              LocaleKeys.stat_card_balance,
                              style: TextStyle(color: Color(0xff77869E)),
                            ).tr(),
                            subtitle: Text(
                              '\$6,390',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff042C5C)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: ListTile(
                                  leading: Card(
                                    color: Colors.green[100],
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Color(0xff29BF76),
                                      size: 30,
                                    ),
                                  ),
                                  title: Text('\$$incomeBalance',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                      )),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  leading: Card(
                                    color: Colors.red[100],
                                    child: Icon(Icons.arrow_downward,
                                        color: Color(0xffF24750), size: 30),
                                  ),
                                  title: Text('\$$expenceBalance',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 20,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.50,
                  child: AreaAndLineChart(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(LocaleKeys.stat_spending,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))
                        .tr(),
                    FlatButton(
                      child: Text(LocaleKeys.stat_view_budget).tr(),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BudgetPage()));
                      },
                    )
                  ],
                ),
                Container(
                  height: size.height * 0.30,
                  child: _listOfTransactions,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AreaAndLineChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AreaAndLineChart();
  }
}

class _AreaAndLineChart extends State<AreaAndLineChart> {
  Size _size;
  List<charts.Series<Sales, int>> _seriesLineData;
  List<bool> isSelected = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  var menuItem = <String>[LocaleKeys.stat_monthly, LocaleKeys.stat_daily];
  String _selectedText = LocaleKeys.stat_monthly;

  _generateData() {
    var linesalesdata = [
      new Sales(0, 2000),
      new Sales(1, 9000),
      new Sales(2, 6000),
      new Sales(3, 5000),
      new Sales(4, 4000),
      new Sales(5, 5000),
      new Sales(6, 6000),
      new Sales(7, 7000),
      new Sales(8, 8000),
      new Sales(9, 9000),
    ];
    var linesalesdata1 = [
      new Sales(0, 3000),
      new Sales(1, 2000),
      new Sales(2, 6000),
      new Sales(3, 1000),
      new Sales(4, 9000),
      new Sales(5, 5000),
      new Sales(6, 3000),
      new Sales(7, 5000),
      new Sales(8, 4000),
      new Sales(9, 5000),
    ];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.red),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

  Widget get _month {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ListView(
        primary: false,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          DropdownButton<String>(
            items: menuItem.map((value) {
              return DropdownMenuItem<String>(
                  value: value, child: Text(value).tr());
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedText = val;
              });
            },
            value: _selectedText,
          ),
          SizedBox(
            width: 50,
          ),
          ToggleButtons(
            onPressed: (index) {
              setState(() {
                isSelected[index] = !isSelected[index];
              });
            },
            renderBorder: false,
            borderRadius: BorderRadius.circular(18.0),
            children: [
              Text(LocaleKeys.months_jan.tr()),
              Text(LocaleKeys.months_feb.tr()),
              Text(LocaleKeys.months_mar.tr()),
              Text(LocaleKeys.months_apr.tr()),
              Text(LocaleKeys.months_may.tr()),
              Text(LocaleKeys.months_jun.tr()),
              Text(LocaleKeys.months_jul.tr()),
              Text(LocaleKeys.months_ags.tr()),
              Text(LocaleKeys.months_seb.tr()),
              Text(LocaleKeys.months_oct.tr()),
              Text(LocaleKeys.months_nov.tr()),
              Text(LocaleKeys.months_dec.tr()),
            ],
            isSelected: isSelected,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();

    _generateData();
  }

  @override
  void didChangeDependencies() {
    _size = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Container(height: _size.height * 0.50 * 0.15, child: _month),
        Container(
          height: _size.height * 0.50 * 0.80,
          width: double.infinity,
          child: charts.LineChart(_seriesLineData,
              defaultRenderer: new charts.LineRendererConfig(
                  includeArea: true, stacked: true),
              animate: true,
              animationDuration: Duration(seconds: 5),
              behaviors: []),
        ),
      ],
    );
  }
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}
