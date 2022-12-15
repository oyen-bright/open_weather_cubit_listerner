// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_cubit/Exception/weather_exception.dart';
import 'package:open_weather_cubit/constants/constants.dart';
import 'package:open_weather_cubit/models/geocoding.dart';
import 'package:open_weather_cubit/models/weather.dart';
import 'package:open_weather_cubit/service/http_error_hadler.dart';

class WeatherApiService {
  final http.Client httpClient;
  WeatherApiService({
    required this.httpClient,
  });

  Future<GeoCoding> getDirectGeoCoding(String city) async {
    final Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/geo/1.0/direct',
        queryParameters: {
          "q": city,
          "limit": kLimit,
          "appid": dotenv.env["APPID"]
        });
    print(uri);
    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw httpErrorHandler(response);
      }
      final responseBody = json.decode(response.body);

      print(responseBody);

      if (responseBody.isEmpty) {
        throw WeatherException('Cannot get the location of $city');
      }

      return GeoCoding.fromJson(responseBody);
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(GeoCoding directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: kApiHost,
      path: '/data/2.5/weather',
      queryParameters: {
        'lat': '${directGeocoding.lat}',
        'lon': '${directGeocoding.log}',
        'units': kUnit,
        'appid': dotenv.env['APPID'],
      },
    );

    try {
      final http.Response response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final weatherJson = json.decode(response.body);

      final Weather weather = Weather.fromJson(weatherJson);

      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
