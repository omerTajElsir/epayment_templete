import 'package:epayment_templete/bottomsheets/bottomsheets.dart';
import 'package:epayment_templete/consts.dart';
import 'package:epayment_templete/pages/Bills.dart';
import 'package:epayment_templete/pages/add_new_card.dart';
import 'package:epayment_templete/pages/bills/bills_page.dart';
import 'package:epayment_templete/pages/budget/budget_page.dart';
import 'package:epayment_templete/pages/edit_card.dart';
import 'package:epayment_templete/pages/electricity/electricity_page.dart';
import 'package:epayment_templete/pages/schedule/schedule_page.dart';
import 'package:epayment_templete/pages/schedule/todo.dart';
import 'package:epayment_templete/pages/splash/splash_page.dart';
import 'package:epayment_templete/pages/statistics/StatisticsPage.dart';
import 'package:epayment_templete/pages/tab/profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization_provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import '../maps.dart';
import '../month_report.dart';
import '../payment_success.dart';
import '../top_up.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  BuildContext _context;
  Size size;
  String incomeBalance = '3,214';
  String expenceBalance = '1,640';

  final List<Transaction> transaction = [
    Transaction('POS', '12:03:2018 21:15', 123.12, 'CR', 'SDG'),
    Transaction('Bank', '15.03.2018 15:00', 12.42, 'DR', 'SDG'),
    Transaction('POS', '15.03.2018 15:00', 18.22, 'DR', 'SDG'),
  ];

  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: Container(
        width: 500,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Omer',
              style: TextStyle(color: Colors.black, fontSize: 18),
              textAlign: TextAlign.start,
            ),
            SizedBox(width: 5,),
            Text(AppLocalizations.of(context).tr('home.good_morning'),
                style: TextStyle(color: Color(0xff042C5C), fontSize: 12),
                textAlign: TextAlign.start),
          ],
        ),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.person,color: Colors.black,), onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Profile()));
        }),

      ],
      leading: IconButton(
          icon: Image.asset('assets/menu-icon.png'), onPressed: () {
        _scaffoldKey.currentState.openDrawer();
      }),
      centerTitle: false,
    );
  }

  get _getDrawer{
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.grey.shade400),
            accountEmail: Text("omertaj39@gmail.com",style: TextStyle(color: Colors.black),),
            accountName: Text("Omer Tajelsir",style: TextStyle(color: Colors.black),),
            currentAccountPicture: GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/profileimg.png"),
              ),
            ),
          ),
          // body
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text('Home Page'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('My account'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>Profile()));
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text('Statistics'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>StatisticsPage()));

            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Budget'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>BudgetPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.date_range),
            title: Text('Mounth Report'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>MonthReport()));
            },
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Schedule'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void>(builder: (context)=>TodoTwoPage()));
            },
          ),
          Divider(),

          Divider(),
          ListTile(
            leading: Icon(Icons.power_settings_new),
            title: Text('Logout',style: TextStyle(color: Colors.red),),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (context)=>SplashPage()));
            },
          ),
        ],
      ),
      elevation: 1.5,
    );
  }
  var pageCont = PageController(viewportFraction: 1 / 1.2);
  //get card list
  Widget _getCardList(BuildContext context) {
    return PageView(
      controller: pageCont,
      onPageChanged: (pageIndex){
        if(pageIndex == 0){
          setState(() {
            cardName = "First Card";
          });

        }else if(pageIndex == 1){
          setState(() {
            cardName = "Second Card";
          });

        }else{
          setState(() {
            cardName = "Unknown Card";
          });

        }
      },
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 0,right: 10),
          height: size.height * 0.20,
          width: size.width * 0.70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/cardbg.png'), fit: BoxFit.fill)),
          child: InkWell(
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.edit,color: Colors.lightBlueAccent,),
                    onPressed: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => EditCard()));

                    },
                  ),
                ),
                Positioned(
                    left: 20.0,
                    bottom: 40.0,
                    child: Text(
                      'xxxx xxxx xxxx 2854',
                      style: TextStyle(color: Colors.white,letterSpacing: 3),
                    )),
                Positioned(
                    right: 20.0,
                    bottom: 20.0,
                    child: Text(
                      '03/20',
                      style: TextStyle(color: Colors.white),
                    )),
                Positioned(
                    left: 20.0,
                    bottom: 20.0,
                    child: Text(
                      'John Doe',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => StatisticsPage()));
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          height: size.height * 0.20,
          width: size.width * 0.70,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/cardfg.png'), fit: BoxFit.fill)),
          child: InkWell(
            child: Stack(
              children: <Widget>[
                Positioned(
                  right: 10,
                  top: 10,
                  child: IconButton(
                    icon: Icon(Icons.edit,color: Colors.lightBlueAccent,),
                    onPressed: (){
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => EditCard()));
                    },
                  ),
                ),
                Positioned(
                    left: 20.0,
                    bottom: 40.0,
                    child: Text(
                      'xxxx xxxx xxxx 2856',
                      style: TextStyle(color: Color(0xFF042C5C),letterSpacing: 3),
                    )),
                Positioned(
                    right: 20.0,
                    bottom: 20.0,
                    child: Text(
                      '03/22',
                      style: TextStyle(color: Color(0xFF042C5C)),
                    )),
                Positioned(
                    left: 20.0,
                    bottom: 20.0,
                    child: Text(
                      'John Doe',
                      style: TextStyle(color: Color(0xFF042C5C)),
                    ))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => StatisticsPage()));
            },
          ),
        ),
        SizedBox(
          width: 50,
          height: 50,
          //color: Colors.blue,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AddNewCard()));
            },
            child: Container(
              width: 50,
              height: 50,
              child: Align(
                alignment: Alignment.centerLeft,

                child: Container(
                  width: 50,
                  height: 50,
                  //color: Colors.blue,
                  child: Material(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade300,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )

      ],
    );
  }

  get _geBeneficiaryList {
    return ListView(scrollDirection: Axis.horizontal, children: <Widget>[
      Container(
        width: size.width * 0.30,
        child: Card(
          child: InkWell(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/plus.png'),
                Text(
                  AppLocalizations.of(context).tr('home.add_beneficiary'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset('assets/m1.png'),
                Text('Omer')
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset('assets/m2.png'),
                Text('Omer')
              ],
            ),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: Card(
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.asset('assets/m3.png'),
                Text('Omer')
              ],
            ),
            onTap: () {},
          ),
        ),
      ),
    ]);
  }

  get _geBillesrsList {
    return ListView(scrollDirection: Axis.horizontal, children: <Widget>[
      Container(
        width: size.width * 0.30,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ElectricityPage()));
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/payee/elecG.png',
                    height: 60,
                    width: 90,
                  ),
                ),
                Text(AppLocalizations.of(context).tr('Electricity.title'))
              ],
            ),
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TopUp()));
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/payee/topupG.png',
                    height: 60,
                    width: 90,
                  ),
                ),
                Text(AppLocalizations.of(context).tr('TopUp.title'))
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  get _geYouWantList {
    return ListView(scrollDirection: Axis.horizontal, children: <Widget>[
      Container(
        width: size.width * 0.30,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Bills()));
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/bills.png',
                    height: 60,
                    width: 90,
                  ),
                ),
                Text(AppLocalizations.of(context).tr('home.bills'))
              ],
            ),
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Maps()));
          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/atm.png',
                    height: 60,
                    width: 90,
                  ),
                ),
                Text(AppLocalizations.of(context).tr('home.ATM'))
              ],
            ),
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: GestureDetector(
          onTap: (){
            showModalBottomSheet(
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
                                                      GestureDetector(
                                                        onTap:() async {
                                                          bottomSheetQR(context);

                                                      },
                                                        child: Container(
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
                                                      ),

                                                      GestureDetector(
                                                        onTap:()async{
                                                          //bottomSheetQR(context);
                                                          String
                                                          photoScanResult = await scanner.scan();
                                                          print(photoScanResult);
                                                          Navigator.pop(context);
                                                          bottomSheetSuccess(context);
                                                        },
                                                        child: Container(
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
                                        borderRadius: BorderRadius.circular(12)));

          },
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/qr.png',
                    height: 60,
                    width: 90,
                  ),
                ),
                Text(AppLocalizations.of(context).tr('home.qr'))
              ],
            ),
          ),
        ),
      ),
      Container(
        width: size.width * 0.30,
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/states.png',
                  height: 60,
                  width: 90,
                ),
              ),
              Text(AppLocalizations.of(context).tr('home.states'))
            ],
          ),
        ),
      ),
    ]);
  }

  get _listOfTransactions {
    return Card(
      child: ListView.builder(
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
    _context=this.context;
    size = MediaQuery.of(context).size;
    return EasyLocalizationProvider(
      data: EasyLocalizationProvider.of(context).data,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: _getAppbar,
        drawer: _getDrawer,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                _sizeBox,
                Container(
                  height: size.height * 0.20,
                  child: _getCardList(context),
                ),
                _sizeBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).tr('home.rem_amount'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Color(0xff042C5C))),
                    Text("  ( $cardName ) ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
                _sizeBox,
                Container(
                  height: 6,
                  width: size.width * 0.90,
                  child: IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.60,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  Localizations.localeOf(context).languageCode == "en"
                                      ? BorderRadius.horizontal(
                                          left: Radius.circular(10))
                                      : BorderRadius.horizontal(
                                          right: Radius.circular(10))),
                          
                        ),
                        Container(
                            width: size.width * 0.30,
                            
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    Localizations.localeOf(context).languageCode == "en"
                                        ? BorderRadius.horizontal(
                                            right: Radius.circular(10))
                                        : BorderRadius.horizontal(
                                            left: Radius.circular(10)))
                            
                            )
                      ],
                    ),
                  ),
                ),
                _sizeBox,
                Container(
                  height: size.height * 0.10,
                  margin: EdgeInsets.only(left: 0,right: 0),
                  child: IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
                        Expanded(
                          child: ListTile(
                            leading: Card(
                              color: Colors.green[100],
                              child: Icon(
                                Icons.arrow_upward,
                                color: Color(0xff29BF76),
                                size: 50,
                              ),
                            ),
                            title: Text(
                                AppLocalizations.of(context)
                                    .tr('home.amount.income'),
                                style: TextStyle(color: Color(0xff042C5C),fontSize: 12)),
                            subtitle: Text('$incomeBalance',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Card(
                              color: Colors.red[100],
                              child: Icon(Icons.arrow_downward,
                                  color: Color(0xffF24750), size: 50),
                            ),
                            title: Text(
                                AppLocalizations.of(context)
                                    .tr('home.amount.expense'),
                                style: TextStyle(color: Color(0xff042C5C),fontSize: 12)),
                            subtitle: Text('$expenceBalance',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _sizeBox,
                Text(AppLocalizations.of(context).tr('home.send_money'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                _sizeBox,
                Container(
                  height: size.height * 0.20,
                  child: _geBeneficiaryList,
                ),
                _sizeBox,
                Text(AppLocalizations.of(context).tr('Favorite.billers'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                _sizeBox,
                Container(
                  height: size.height * 0.20,
                  child: _geBillesrsList,
                ),
                _sizeBox,
                Text(AppLocalizations.of(context).tr('home.you_want'),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                _sizeBox,
                Container(
                  height: size.height * 0.20,
                  child: _geYouWantList,
                ),
                _sizeBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).tr('home.last_trans'),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    FlatButton(
                      child: Text(
                          AppLocalizations.of(context).tr('home.see_more')),
                      onPressed: () {},
                    )
                  ],
                ),
                Container(
                  
                  height: size.height * 0.25,
                  child: _listOfTransactions,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  get _sizeBox => SizedBox(
        height: 10,
      );
}

class Transaction {
  final String name;
  final String time;
  final double amount;
  final String drcr;
  final String curr;

  Transaction([this.name, this.time, this.amount, this.drcr, this.curr]);
}
