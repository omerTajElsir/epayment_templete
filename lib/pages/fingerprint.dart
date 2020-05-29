import 'dart:io';

import 'package:epayment_templete/bottomsheets/bottomsheets.dart';
import 'package:epayment_templete/pages/home/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:local_auth/local_auth.dart';

import '../consts.dart';

class FingerPrint extends StatefulWidget {
  @override
  _FingerPrintState createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {
  void fingerscan() async {
    var localAuth = LocalAuthentication();
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    bool didAuthenticate = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Please authenticate to show account balance');
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        // Face ID.
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        // Touch ID.
      }
    }
    if (didAuthenticate == true) {
      showDialog(
          context: context,
          // barrierDismissible: false,
          builder: (BuildContext context) => dialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;

    ResponsiveWidgets.init(context,
        referenceHeight: 1920, // Optional
        referenceWidth: 1080, // Optional
        referenceShortestSide: 411 // Optional,
        );

    return EasyLocalizationProvider(
      data: data,
      child: ResponsiveWidgets.builder(
        child: Scaffold(
            backgroundColor: Color(0xffDBA14F),
            body: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsResponsive.only(top: 20.0, right: 20,left:20 ),
                      child: GestureDetector(
                        onTap: () {
                          bottomSheetFailed(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                            // alignment: Alignment.topRight,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)
                                    .tr('fingerprint.Next'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ]),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                              onLongPress: () {
                                fingerscan();
                              },
                              child: Image.asset(
                                  'assets/fingerprint/fingerprint-white.png')),
                          Padding(
                            padding: EdgeInsetsResponsive.only(
                              top: 20.0,
                            ),
                            child: Align(
                              child: Text(
                                AppLocalizations.of(context)
                                    .tr('fingerprint.Tap and hold to scan'),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container()
                  ]),
            )),
      ),
    );
  }

  dynamic dialog() {
    return Dialog(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(5),
      // ),
      elevation: 0.0,

      child: Container(
        height: 289,
        width: 343,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsetsResponsive.only(top: 31.0),
            child: Image.asset('assets/fingerprint/fingerprint-colored.png'),
          ),
          Padding(
            padding: EdgeInsetsResponsive.only(top: 20.0),
            child: Text(
              AppLocalizations.of(context).tr('fingerprint.Scanned'),
              style: TextStyle(color: Colors.black, fontSize: 23),
            ),
          ),
          Padding(
            padding: EdgeInsetsResponsive.only(top: 12.0),
            child: Text(
              AppLocalizations.of(context).tr(
                  'fingerprint.Your Fingerprint Is \n Has Been Successfully Scanned'),
              style: TextStyle(
                color: Color(0xffBBBBBB),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 2,
            margin: EdgeInsetsResponsive.only(top: 16.5, right: 20, left: 20),
            color: Color(0xffBBBBBB),
          ),
          Padding(
            padding: EdgeInsetsResponsive.only(top: 14),
            child: FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: Text(
                AppLocalizations.of(context).tr('fingerprint.OK'),
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
