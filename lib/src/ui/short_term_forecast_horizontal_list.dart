import 'package:flutter/material.dart';
import '../models/forecast_model.dart';
import 'short_term_forecast_view.dart';

class ShortTermForecastHorizontalList extends StatelessWidget {

  const ShortTermForecastHorizontalList({
    Key key,
    @required this.shortTerms,
  }) : super(key: key);

  final List<ForecastModel> shortTerms;

  @override
  Widget build(BuildContext context) {
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
          itemCount: shortTerms.length,
          itemBuilder: (context, index) {
            return ShortTermForecastView(
              shortTerm: shortTerms[index],
            );
          },
        ),
      ),
    );
  }
}