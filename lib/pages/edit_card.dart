import 'package:epayment_templete/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts.dart';

class EditCard extends StatefulWidget {
  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  FocusNode textSecondFocusNode = FocusNode();

  Size size;
  bool _check = false;

  get sizedBox => SizedBox(height: 20,);
  final _cNo = TextEditingController();
  final _cdate = TextEditingController();
  final _cName= TextEditingController();
  final _meterForm = GlobalKey<FormState>();


  @override
  void initState() {
    _cName.text = cardName;
    _cNo.text = "92224453343355545";
    _cdate.text = "22/12";
    super.initState();
  } // Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Text(
              'Edit Card',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.left,
            ),
            Text("  ( $cardName ) ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
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
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _getAppbar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _meterForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                sizedBox,

                sizedBox,
                TextFormField(
                  controller: _cNo,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {

                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                  },
                ),

                sizedBox,
                TextFormField(
                  controller: _cdate,
                  decoration: const InputDecoration(labelText: 'Expiry Date'),
                  keyboardType: TextInputType.number,
                  validator: (value) {

                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                  },
                ),

                sizedBox,
                TextFormField(
                  controller: _cName,
                  decoration: const InputDecoration(labelText: 'Card Name'),
                  keyboardType: TextInputType.number,
                  validator: (value) {

                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                  },
                ),
                sizedBox,
                CheckboxListTile(
                  title: Text("Primary Card"),
                  value: _check,
                  onChanged: (newValue) {
                    setState(() {
                      _check= newValue;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                sizedBox,
                ButtonTheme(
                      minWidth: size.width,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          if(_meterForm.currentState.validate()){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));

                          }
                        },
                        // onPressed: () =>
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (context) => ConfirmPage(
                        //               phoneNumber: _phoneNumber.text,
                        //             ))),
                        child: Text(
                          'Pay',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
