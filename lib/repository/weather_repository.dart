import 'package:open_weather_cubit/models/geocoding.dart';

import '../Exception/weather_exception.dart';
import '../models/customerror.dart';
import '../models/weather.dart';
import '../service/weatherapiservice.dart';

class WeatherRepository {
  final WeatherApiService weatherApiServices;
  WeatherRepository({
    required this.weatherApiServices,
  });

  Future<Weather> fetchWeather(String city) async {
    try {
      final GeoCoding directGeocoding =
          await weatherApiServices.getDirectGeoCoding(city);
      print('directGeocoding: $directGeocoding');

      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);

      final Weather weather = tempWeather.copyWith(
        name: directGeocoding.name,
        country: directGeocoding.country,
      );

      print('directGeocoding: $tempWeather');

      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
