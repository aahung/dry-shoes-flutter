import 'dart:async';
import 'weathernetwork_api_provider.dart';
import '../models/city_forecast_model.dart';

class Repository {
  final WeatherNetworkApiProvider weatherNetworkApiProvider = WeatherNetworkApiProvider();

  Future<CityForecastModel> fetchCityForecast(final String cityCode, final String tempUnit) => weatherNetworkApiProvider.fetchCityForecast(cityCode, tempUnit); 
}