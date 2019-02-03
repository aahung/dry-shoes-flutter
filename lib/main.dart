import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/ui/city_forecast_list.dart';

void main() => runApp(MyApp());

const defaultLocation = 'Vancouver';
const defaultCode = 'CABC0308';
const defaultUnit = 'C';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      title: 'DryShoes',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Dry Shoes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  
  String _location;
  String _code;
  String _unit;
  SharedPreferences prefs;

  Future<void> loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _location = prefs.getString('location') ?? defaultLocation;
      _unit = prefs.getString('unit') ?? defaultUnit;
      _code = prefs.getString('code') ?? defaultCode;
    });
  }

  Future<void> savePrefs() async {
    prefs.setString('location', _location);
    prefs.setString('unit', _unit);
    prefs.setString('code', _code);
  }

  void _setUnitF(f) {
    setState(() {
      _unit = f ? 'F' : 'C';
      savePrefs();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadPrefs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // force rebuild so it can fetch
      setState(() {
        _code = _code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(_location),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: <Widget>[
                Text('°C'),
                Switch(
                  value: _unit == 'F',
                  onChanged: (value) => this._setUnitF(value),
                  activeTrackColor: Color(0x99224499),
                  inactiveTrackColor: Color(0x99224499),
                  activeColor: Color(0xFFFFFFFF),
                  inactiveThumbColor: Color(0xFFFFFFFF),
                ),
                Text('°F'),
              ],
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _code == null ? Container : CityForecastList(
              cityCode: _code,
              tempUnit: _unit,
            ),
          ),
        ],
      ),
    );
  }
}