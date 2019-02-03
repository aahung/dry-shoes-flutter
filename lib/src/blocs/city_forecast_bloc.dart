import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/city_forecast_model.dart';

class CityForecastBloc {
  final _repository = Repository();
  final _cityForecastFetcher = PublishSubject<CityForecastModel>();

  Observable<CityForecastModel> get cityForecast => _cityForecastFetcher.stream;

  fetchCityForecast(final String cityCode, final String tempUnit) async {
    CityForecastModel cityForecastModel = await _repository.fetchCityForecast(cityCode, tempUnit);
    _cityForecastFetcher.sink.add(cityForecastModel);
  }

  dispose() {
    _cityForecastFetcher.close();
  }
}

final bloc = CityForecastBloc();