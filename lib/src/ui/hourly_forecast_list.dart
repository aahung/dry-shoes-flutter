import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../models/forecast_model.dart';
import 'hourly_forecast_view.dart';

class HourlyForecastList extends StatelessWidget {

  const HourlyForecastList({
    Key key,
    @required this.day,
    @required this.hourlies,
  }) : super(key: key);

  final String day;
  final List<ForecastModel> hourlies;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: new Container(
        height: 30.0,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: new EdgeInsets.all(10.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              day,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'feels like',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
      content: Column(
        children: hourlies.map<Widget>(buildHourly).toList(),
      ),
    );
  }

  Widget buildHourly(final ForecastModel hourly) {
    return HourlyForecastView(
      hourly: hourly,
    );
  }
}