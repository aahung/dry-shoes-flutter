import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

void main() => runApp(MyApp());

const defaultLocation = 'Vancouver';
const defaultCode = 'CABC0308';
const defaultUnit = 'C';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  
  var _lastResultTime = 0;
  var _location = defaultLocation;
  var _code = defaultCode;
  var _unit = defaultUnit;
  var _hourlies = [];
  var _shortTerms = [];
  SharedPreferences prefs;

  Future<void> _refresh() async {
    try {
      var url = 'https://appframework.pelmorex.com/api/appframework/'
          + 'WeatherData/getData/iPhone?appVersion=5.3.0.1498&configVersion=103&'
          + 'dataType=Hourly,ShortTerm&deviceLang=en-US&deviceLocale=en-US&'
          + 'location=$_code&measurementUnit=metric&resourceCommonVersion=0&'
          + 'resourceVersion=0&tempUnit=$_unit';
      final response = await http.get(url);
      final responseJson = jsonDecode(response.body);
      setState(() {
        _hourlies = responseJson['Hourly']['Hourlies'];
        _shortTerms = responseJson['ShortTerm']['ShortTerms'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

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
      _refresh();
      savePrefs();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadPrefs().then((_) => _refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refresh();
    }
  }

  Widget buildHourly(hourly) {
    var rainValue = hourly['RainValue'];
    if (hourly['RainUnit'] == 'cm') {
      rainValue *= 10;
    }
    const fullRainValue = 5;
    final percentage = min<double>(rainValue / fullRainValue, 1.0);
    dynamic image = Text('');
    final String icon = hourly['Icon'];
    if (icon.startsWith('wxicon')) {
      final iconNum = int.parse(icon.split('wxicon')[1]);
      if (iconNum >= 1 && iconNum <= 33) {
        image = Image.asset(
          'assets/wxicons/$iconNum.png',
          height: 20,
        );
      }
    } 
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 70.0,
                    child: Text(
                      hourly['Period'],
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                  OrientationBuilder(
                    builder: (context, orientation) {
                      return LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width - 160,
                        progressColor: Colors.blueAccent,
                        backgroundColor: Colors.transparent,
                        percent: percentage,
                      );
                    }
                  ),
                  Container(
                    width: 70.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          hourly['FeelsLike'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          hourly['TemperatureDegree'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text(
                          hourly['TemperatureUnit'],
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      image,
                      Text(
                        ' ' + hourly['Condition'],
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    hourly['RainDisplay'] + hourly['RainUnit'],
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: hourly['RainDisplay'] == '0' ? Colors.transparent : Colors.black,
                    ),
                  )
                ],
              )
            ],
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    var numSection = 0;
    if (_shortTerms.length > 0) numSection += 1;
    var groups = [];
    var groupedHourlies = {};
    for (var hourly in _hourlies) {
      final day = hourly['PeriodDay'];
      if (!groups.contains(day)) {
        groups.add(day);
        groupedHourlies[day] = [];
        numSection += 1;
      }
      groupedHourlies[day].add(hourly);
    }

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
            child: LiquidPullToRefresh(
              onRefresh: _refresh,
              showChildOpacityTransition: false,
              child: ListView.builder(
                itemCount: numSection,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return MediaQuery( // freeze the text scaling because it will affect the height
                      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x11000000),
                              blurRadius: 4.0, // has the effect of softening the shadow
                              spreadRadius: 0.0, // has the effect of extending the shadow
                              offset: Offset(
                                0.0, 6.0
                              ),
                            )
                          ]
                        ),
                        height: 200,
                        margin: EdgeInsets.only(bottom: 20.0),
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: _shortTerms.length,
                          itemBuilder: (context, index) {
                            final shortTerm = _shortTerms[index];
                            final feelLike = shortTerm['FeelsLike']
                              + shortTerm['TemperatureDegree']
                              + shortTerm['TemperatureUnit'];
                            final rain = (shortTerm['RainDisplay']) == '0' ? 
                              ':-)' : shortTerm['RainDisplay'] + shortTerm['RainUnit'];
                            var decoration;
                            final String icon = shortTerm['Icon'];
                            if (icon.startsWith('wxicon')) {
                              final iconNum = int.parse(icon.split('wxicon')[1]);
                              if (iconNum >= 1 && iconNum <= 33) {
                                decoration = BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/wxicons/$iconNum.png'),
                                    fit: BoxFit.contain,
                                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop)
                                  ),
                                );
                              }
                            } 
                            return Container(
                              width: 150.0,
                              padding: EdgeInsets.all(20.0),
                              decoration: decoration,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    shortTerm['PeriodDay'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  Text(
                                    shortTerm['Period'],
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    shortTerm['WindSpeed'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    feelLike,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  Text(
                                    rain,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              )
                            );
                          },
                        ),
                      ),
                    );
                  }
                  final group = groups[index - 1];
                  var groupText = (group == groups[0]) ? 'Today' : group;
                  final hourlies = groupedHourlies[group];
                  return StickyHeader(
                    header: new Container(
                      height: 30.0,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      padding: new EdgeInsets.all(10.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(groupText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    content: Column(
                      children: hourlies.map<Widget>(buildHourly).toList(),
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}