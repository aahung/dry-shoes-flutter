import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/city_forecast_model.dart';

class WeatherNetworkApiProvider {
  Future<CityForecastModel> fetchCityForecast(final String cityCode, final String tempUnit) async {
    try {
      var url = 'https://appframework.pelmorex.com/api/appframework/'
          + 'WeatherData/getData/iPhone?appVersion=5.3.0.1498&configVersion=103&'
          + 'dataType=Hourly,ShortTerm&deviceLang=en-US&deviceLocale=en-US&'
          + 'location=$cityCode&measurementUnit=metric&resourceCommonVersion=0&'
          + 'resourceVersion=0&tempUnit=$tempUnit';
      final response = await http.get(url);
      final responseJson = jsonDecode(response.body);
      return CityForecastModel.fromJSON(responseJson);
    } catch (e) {
      throw e;
    }
  }
}