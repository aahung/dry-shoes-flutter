import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/forecast_model.dart';

class HourlyForecastView extends StatelessWidget {

  const HourlyForecastView({
    Key key,
    @required this.hourly,
  }) : super(key: key);

  final ForecastModel hourly;

  @override
  Widget build(BuildContext context) {
    final percentage = hourly.snowPercentage > 0 ? hourly.snowPercentage : hourly.rainPercentage;
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
                      hourly.period,
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
                          hourly.temperature,
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
                      Image.asset(
                        hourly.iconPath,
                        height: 20,
                      ),
                      Text(
                        ' ' + hourly.condition,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    hourly.snowValue > 0 ? hourly.snow : hourly.rain,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: (hourly.rainValue + hourly.snowValue) == 0 ? Colors.transparent : Colors.black,
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
}