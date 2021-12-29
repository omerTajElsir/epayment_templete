import 'package:easy_localization/easy_localization.dart';
import 'package:epayment_templete/generated/locale_keys.g.dart';
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  padding: EdgeInsets.only(left: 20.0, top: 28, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        LocaleKeys.dialog_Send,
                        style: TextStyle(color: Colors.black, fontSize: 22),
                      ).tr(),
                      Text(
                        LocaleKeys.dialog_Not_working,
                        style: TextStyle(color: Colors.black38, fontSize: 14),
                      ).tr(),
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    LocaleKeys.dialog_Transfer_is_Successfull,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ).tr(),
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                    LocaleKeys.dialog_Pay,
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
                    LocaleKeys
                        .dialog_It_seems_like_your_balance_is_insufficient_please_top_up_and_try_again,
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
