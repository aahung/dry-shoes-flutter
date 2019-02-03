import 'package:flutter/material.dart';
import '../models/forecast_model.dart';

class ShortTermForecastView extends StatelessWidget {

  const ShortTermForecastView({
    Key key,
    @required this.shortTerm,
  }) : super(key: key);

  final ForecastModel shortTerm;

  @override
  Widget build(BuildContext context) {
    final feelLike = shortTerm.temperature;
    final rainOrSnow = shortTerm.rainValue == 0 ? (shortTerm.snowValue == 0 ? ':-)' : shortTerm.snow) : shortTerm.rain;
    var decoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage(shortTerm.iconPath),
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop)
      ),
    );
    
    return Container(
      width: 150.0,
      padding: EdgeInsets.all(20.0),
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            shortTerm.periodDay,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w100,
            ),
          ),
          Text(
            shortTerm.period,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            shortTerm.wind,
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
            rainOrSnow,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      )
    );
  }
}