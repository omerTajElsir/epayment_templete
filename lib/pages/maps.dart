import 'package:easy_localization/easy_localization.dart';
import 'package:epayment_templete/generated/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);
  final LatLng _center1 = const LatLng(45.522563, -122.679433);
  var selected = 1;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final marker = Marker(
      markerId: MarkerId('markerId'),
      position: _center1,
      infoWindow: InfoWindow(
        title: '205',
      ),
    );
    _markers['markerId'] = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Card(
            elevation: 1,
            margin: EdgeInsets.all(0),
            child: Container(
              color: Colors.white,
              height: 110,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 3),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: 30,
                                      color: Colors.grey[800],
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })),
                            SizedBox(
                              width: 3,
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  LocaleKeys.Maps_title,
                                  style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ).tr()),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    size: 23,
                                    color: Colors.grey[700],
                                  ),
                                  onPressed: () {}),
                              IconButton(
                                  icon: Icon(
                                    Icons.menu,
                                    size: 23,
                                    color: Colors.grey[700],
                                  ),
                                  onPressed: () {}),
                            ],
                          )),
                    ],
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: selected == 1
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))
                                    : null),
                            child: Center(
                              child: Text(
                                'All Spots',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: selected == 1 ? 18 : 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 2;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: selected == 2
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))
                                    : null),
                            child: Center(
                              child: Text(
                                'Khartoum',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: selected == 2 ? 18 : 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 3;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: selected == 3
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))
                                    : null),
                            child: Center(
                              child: Text(
                                'Omdurman',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: selected == 3 ? 18 : 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = 4;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: selected == 4
                                    ? Border(
                                        bottom: BorderSide(
                                            color: Colors.blue, width: 2))
                                    : null),
                            child: Center(
                              child: Text(
                                'Bahri',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: selected == 4 ? 18 : 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
            ),
          ),
        ],
      )),
    );
  }
}
