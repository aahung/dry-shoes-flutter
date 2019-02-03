import 'dart:math';

class ForecastModel {
  String _period;
  String _periodDay;
  String _condition;
  String _iconPath;
  String _temperature;
  double _rainValue; // mm
  String _rain;
  String _wind;
  double _rainPercentage;

  ForecastModel.fromJSON(Map<String, dynamic> parsedJson) {
    _period = parsedJson['Period'];
    _periodDay = parsedJson['PeriodDay'];
    _condition = parsedJson['Condition'];
    _temperature = parsedJson['Temperature'] + parsedJson['TemperatureDegree'] + parsedJson['TemperatureUnit'];
    _rainValue = parsedJson['RainValue'];
    if (parsedJson['RainUnit'] == 'cm') {
      _rainValue *= 10;
    }
    _rain = parsedJson['Rain'];
    _wind = parsedJson['WindSpeed'];

    const fullRainValue = 5;
    _rainPercentage = min<double>(rainValue / fullRainValue, 1.0);
    final String iconName = parsedJson['Icon'];
    if (iconName.startsWith('wxicon')) {
      final iconNum = int.parse(iconName.split('wxicon')[1]);
      if (iconNum >= 1 && iconNum <= 33) {
        _iconPath = 'assets/wxicons/$iconNum.png';
      }
    } 
  }

  String get period => _period;
  String get periodDay => _periodDay;
  String get condition => _condition;
  String get iconPath => _iconPath;
  String get temperature => _temperature;
  double get rainValue => _rainValue;
  String get rain => _rain;
  String get wind => _wind;
  double get rainPercentage => _rainPercentage;
}