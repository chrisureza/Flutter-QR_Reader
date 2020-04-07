import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_reader_app/src/utils/utils.dart' as utils;
import '../models/scan_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_reader_app/src/bloc/scans_bloc.dart';
import 'package:qr_reader_app/src/pages/directions_page.dart';
import 'package:qr_reader_app/src/pages/maps_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = ScansBloc();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.deleteAllScans,
          ),
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _mainBottomNavBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    // https://chrisureza.com
    // geo:9.915461103865884,-84.17937770327457

    String futureString = 'https://chrisureza.com';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   futureString = e.toString();
    // }

    if (futureString != null) {
      final scan = ScanModel(value: futureString);
      scansBloc.addScan(scan);

      final scan2 =
          ScanModel(value: 'geo:40.724233047051705,-74.00731459101564');
      scansBloc.addScan(scan2);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(context, scan);
        });
      } else {
        utils.openScan(context, scan);
      }
    }
  }

  Widget _callPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return MapsListPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsListPage();
    }
  }

  Widget _mainBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Map'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Directions'),
        ),
      ],
    );
  }
}
