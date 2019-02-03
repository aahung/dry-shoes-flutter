
import 'forecast_model.dart';

class CityForecastModel {
  List<String> _days = [];
  Map<String, List<ForecastModel>> _groupedHourlies = {};
  List<ForecastModel> _hourlies = [];
  List<ForecastModel> _shortTerms = [];

  CityForecastModel.fromJSON(Map<String, dynamic> parsedJson) {
    for (var hourly in parsedJson['Hourly']['Hourlies']) {
      var day = hourly['PeriodDay'];
      if (_days.length == 0) {
        // first day is today
        day = 'Today';
      }
      if (!_days.contains(day)) {
        _days.add(day);
        _groupedHourlies[day] = [];
      }
      _groupedHourlies[day].add(ForecastModel.fromJSON(hourly));
      _hourlies.add(ForecastModel.fromJSON(hourly));
    }

    for (final shortTerm in parsedJson['ShortTerm']['ShortTerms']) {
      _shortTerms.add(ForecastModel.fromJSON(shortTerm));
    }
  }

  List<String> get days => _days;
  Map<String, List<ForecastModel>> get groupedHourlies => _groupedHourlies;
  List<ForecastModel> get hourlies => _hourlies;
  List<ForecastModel> get shortTerms => _shortTerms;
}