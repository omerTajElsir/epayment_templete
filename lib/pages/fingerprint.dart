import 'dart:io';
import 'package:epayment_templete/bottomsheets/bottomsheets.dart';
import 'package:epayment_templete/pages/home/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:local_auth/local_auth.dart';
import '../generated/locale_keys.g.dart';

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
    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
    );

    return ResponsiveWidgets.builder(
      child: Scaffold(
          backgroundColor: Color(0xffDBA14F),
          body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsetsResponsive.only(
                        top: 20.0, right: 20, left: 20),
                    child: GestureDetector(
                      onTap: () {
                        bottomSheetFailed(context);
                      },
                      child: Row(mainAxisAlignment: MainAxisAlignment.end,
                          // alignment: Alignment.topRight,
                          children: <Widget>[
                            Text(
                              LocaleKeys.fingerprint_Next,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ).tr(),
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
                              LocaleKeys.fingerprint_Tap_and_hold_to_scan,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ).tr(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container()
                ]),
          )),
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
              LocaleKeys.fingerprint_Scanned,
              style: TextStyle(color: Colors.black, fontSize: 23),
            ).tr(),
          ),
          Padding(
            padding: EdgeInsetsResponsive.only(top: 12.0),
            child: Text(
              LocaleKeys
                  .fingerprint_Your_Fingerprint_Is_Has_Been_Successfully_Scanned,
              style: TextStyle(
                color: Color(0xffBBBBBB),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ).tr(),
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
                LocaleKeys.fingerprint_OK,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ).tr(),
            ),
          )
        ]),
      ),
    );
  }
}
