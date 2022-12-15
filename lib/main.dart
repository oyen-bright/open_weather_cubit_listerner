import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_weather_cubit/cubits/tempsettings/tempsettings_cubit.dart';
import 'package:open_weather_cubit/cubits/theme/theme_cubit.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_cubit/pages/homepage.dart';
import 'package:open_weather_cubit/repository/weather_repository.dart';
import 'package:open_weather_cubit/service/weatherapiservice.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<WeatherRepository>(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiService(httpClient: http.Client())),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<WeatherCubit>(
              create: (context) => WeatherCubit(
                  weatherRepository: context.read<WeatherRepository>()),
            ),
            BlocProvider<TempsettingsCubit>(
              create: (context) => TempsettingsCubit(),
            ),
            BlocProvider<ThemeCubit>(
              create: (context) => ThemeCubit(),
            ),
          ],
          child: BlocListener<WeatherCubit, WeatherState>(
            listener: (context, state) {
              context.read<ThemeCubit>().checkTeme(state.weather);
            },
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  title: 'Weather app',
                  theme: state.appTheme == AppTheme.dark
                      ? ThemeData.dark()
                      : ThemeData(
                          primarySwatch: Colors.blue,
                        ),
                  home: const Homepage(),
                );
              },
            ),
          )),
    );
  }
}
