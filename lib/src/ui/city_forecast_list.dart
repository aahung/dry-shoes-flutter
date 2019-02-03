import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../models/city_forecast_model.dart';
import '../blocs/city_forecast_bloc.dart';
import 'short_term_forecast_horizontal_list.dart';
import 'hourly_forecast_list.dart';

const defaultCity = 'Vancouver';
const defaultCityCode = 'CABC0308';
const defaultTempUnit = 'C';

class CityForecastList extends StatelessWidget {
  CityForecastList({
    Key key,
    @required this.cityCode,
    @required this.tempUnit,
  }) : super(key: key);

  final String cityCode;
  final String tempUnit;

  @override
  Widget build(BuildContext context) {
    bloc.fetchCityForecast(cityCode, tempUnit);
    return StreamBuilder(
      stream: bloc.cityForecast,
      builder: (context, AsyncSnapshot<CityForecastModel> snapshot) {
        if (snapshot.hasData) {
          return buildList(snapshot);
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildList(AsyncSnapshot<CityForecastModel> snapshot) {
    CityForecastModel cityForecast = snapshot.data;
    return LiquidPullToRefresh(
      onRefresh: () => bloc.fetchCityForecast(cityCode, tempUnit),
      showChildOpacityTransition: false,
      child: ListView.builder(
        itemCount: 1 + cityForecast.days.length,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ShortTermForecastHorizontalList(
              shortTerms: cityForecast.shortTerms,
            );
          }
          final day = cityForecast.days[index - 1];
          final hourlies = cityForecast.groupedHourlies[day];
          return HourlyForecastList(
            day: day,
            hourlies: hourlies,
          );
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
    }
  }
}