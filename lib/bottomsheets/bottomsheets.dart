import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
// import 'package:responsive_widgets/responsive_widgets.dart';


  void bottomSheetQR(context) {
    showModalBottomSheet(
        // useRootNavigator: false,

        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          // return StatefulBuilder(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: 482,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, top: 28, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context)
                              .tr('dialog.Send'),
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .tr('dialog.Not working?'),
                          style: TextStyle(color: Colors.black38, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 163.0),
                  child:
                      GestureDetector(child: Image.asset('assets/qr_code.png')),
                )
              ]),
            ),
          );
          // }
          // );
        });
  }

  void bottomSheetSuccess(context) {
    showModalBottomSheet(
        // useRootNavigator: false,

        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          // return StatefulBuilder(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              
              height: 482,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 28),
                    child: Text(
                       AppLocalizations.of(context)
                              .tr('dialog.Transfer is Successfull'),
                      style: TextStyle(color: Colors.black, fontSize: 22),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 163.0),
                  child: Image.asset('assets/success.png'),
                )
              ]),
            ),
          );
          // }
          // );
        });
  }
 
  void bottomSheetFailed(context) {
    showModalBottomSheet(
        // useRootNavigator: false,

        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          // return StatefulBuilder(builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              
              height: 482,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 28),
                    child: Text(
                        AppLocalizations.of(context)
                              .tr('dialog.Pay'),
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 106.0),
                  child: Image.asset(
                    'assets/failed.png',
                    height: 96,
                    width: 96,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 24),
                    child: Text(
                          AppLocalizations.of(context)
                              .tr('dialog.It seems like your balance is insufficient,\n please top up and try again.'),
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ]),
            ),
          );
          // }
          // );
        });
  }

