import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../payment_success.dart';

class ElectricityPage extends StatefulWidget {
  @override
  _ElectricityPageState createState() => _ElectricityPageState();
}

class _ElectricityPageState extends State<ElectricityPage> {
  FocusNode textSecondFocusNode = FocusNode();

  Size size;

  get sizedBox => SizedBox(height: 20,);
  final _f1 = TextEditingController();
  final _f2 = TextEditingController();
  final _f3= TextEditingController();
  final _f4 = TextEditingController();
  final _amount = TextEditingController();
  final _meterForm = GlobalKey<FormState>();
  // Returns "Appbar"
  get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: SizedBox(
        width: double.infinity,
        child: Text(
          'Electricity',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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

  Widget _elecriciyTextFaild(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Flexible(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: InputDecoration(),
              validator: (value) {

                if (value.isEmpty) {
                  return '4 digits';
                }else if(value.length != 4){
                  return '4 digits';
                }
              },),
          ),
        ),
        new Flexible(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: InputDecoration(),
              validator: (value) {

                if (value.isEmpty) {
                  return '4 digits';
                }else if(value.length != 4){
                  return '4 digits';
                }
              },),
          ),
        ),
        new Flexible(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: InputDecoration(),
              validator: (value) {

                if (value.isEmpty) {
                  return '4 digits';
                }else if(value.length != 4){
                  return '4 digits';
                }
              },),
          ),
        ),
        new Flexible(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new TextFormField(
                keyboardType: TextInputType.number,

                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: InputDecoration(),
              validator: (value) {

                if (value.isEmpty) {
                  return '4 digits';
                }else if(value.length != 9){
                  return '4 digits';
                }
              },),
          ),
        ),
      ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Color(0xff707070),
                      onPressed: () {},
                      child: Text('New'),
                    ),
                    FlatButton(onPressed: () {}, child: Text('Saved'))
                  ],
                ),
                sizedBox,
                Text('Meter No.'),
                _elecriciyTextFaild(context),
                // TextFormField(
                //   decoration: const InputDecoration(labelText: 'Meter No.'),
                //   keyboardType: TextInputType.multiline,
                //   maxLines: 4,
                // ),
                sizedBox,
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {

                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                  },
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
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentSuccess()));

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
