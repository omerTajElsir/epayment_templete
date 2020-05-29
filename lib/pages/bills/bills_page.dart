import 'package:epayment_templete/pages/top_up.dart';
import 'package:flutter/material.dart';

class BillsPage extends StatefulWidget {
  @override
  _BillsPageState createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {
  static BuildContext _context;
  // Variables
  Size _screenSize;

  // Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Text(
          'Bills',
          style:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.left,
        ),
      ),
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }



  @override
  Widget build(BuildContext context) {

    final _payeeList = <Widget>[
      GestureDetector(

        child: ListTile(
            contentPadding: EdgeInsets.all(10),
            subtitle: Text('Our Available Payees List')),
      ),
      GestureDetector(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopUp()));
        },
        child: ListTile(
          title: Text('Hajj'),
          subtitle: Text('Hajj Services'),
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.red,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/payee/hajj.png'))),
        ),
      ),
      ListTile(
        title: Text('MOHE'),
        subtitle: Text('Ministory of Education'),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/payee/tax.png'))),
      ),
      ListTile(
        title: Text('Tax'),
        subtitle: Text('Tax Services'),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/payee/tax.png'),
            )
        ),
      ),
      ListTile(
        title: Text('E15'),
        subtitle: Text('E15 Services'),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Image.asset('assets/payee/e15.png'))),
      ),
      ListTile(
        title: Text('Electricity'),
        subtitle: Text('Electricity Services'),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/payee/topUp.png'))),
      ),
      ListTile(
        title: Text('Top Up'),
        subtitle: Text('Telecom Operator'),
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.red,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/payee/topUp.png'))),
      ),
    ];

    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _getAppbar,
      body: Container(
        child: ListView(
          children: _payeeList,
        ),
      ),
    );
  }
}
