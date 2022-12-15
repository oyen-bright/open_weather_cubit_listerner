import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/cubits/tempsettings/tempsettings_cubit.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_cubit/pages/searchpage.dart';
import 'package:open_weather_cubit/pages/settingpage.dart';
import 'package:open_weather_cubit/widgets/errorWidget.dart';
import 'package:recase/recase.dart';

import '../constants/constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SearchPage()));
                if (_city != null) {
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              },
              icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingPage()));
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: _showWeather(),
    );
  }
}

String _showTemperature(double temperature, BuildContext context) {
  final tempUnit = context.watch<TempsettingsCubit>().state.tempunit;

  if (tempUnit == TempUnit.fahrenheit) {
    return '${((temperature * 9 / 5) + 32).toStringAsFixed(2)}℉';
  }

  return '${temperature.toStringAsFixed(2)}℃';
}

Widget _Inputcity(BuildContext context) {
  String? city;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            autofocus: true,
            style: const TextStyle(fontSize: 18.0),
            decoration: const InputDecoration(
              labelText: 'City name',
              hintText: 'more than 2 characters',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            validator: (String? input) {
              if (input == null || input.trim().length < 2) {
                return 'City name must be at least 2 characters long';
              }
              return null;
            },
            onChanged: ((value) {
              city = value;
            }),
            onSaved: (String? input) {
              city = input;
            },
          ),
        ),
        IconButton(
            onPressed: () {
              context.read<WeatherCubit>().fetchWeather(city!);
            },
            icon: const Icon(Icons.check))
      ],
    ),
  );
}

Widget formatText(String description) {
  final formattedString = description.titleCase;
  return Text(
    formattedString,
    style: const TextStyle(fontSize: 15.0),
    textAlign: TextAlign.center,
  );
}

Widget _showIcon(String iconUrl) {
  return FadeInImage(
      placeholder: const NetworkImage(
          "https://media.tenor.com/6Pjav1LgBIAAAAAC/tenkahyakken-chatannakiri.gif",
          scale: 10),
      image: NetworkImage('http://$kIconHost/img/wn/$iconUrl@4x.png'));
}

Widget _showWeather() {
  return BlocConsumer<WeatherCubit, WeatherState>(builder: ((context, state) {
    print(state.status);
    if (state.status == WeatherStatus.initial) {
      return const Center(child: Text("Select a city"));
    } else if (state.status == WeatherStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (state.status == WeatherStatus.error && state.weather.name == '') {
        return const Center(
          child: Text(
            'Selec a city* ',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      return ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          // _Inputcity(context),
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Text(
            state.weather.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(TimeOfDay.fromDateTime(state.weather.lastUpdated)
                  .format(context)),
              const SizedBox(width: 10.0),
              Text(
                '(${state.weather.country})',
                style: const TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_showTemperature(state.weather.temp, context)),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(_showTemperature(state.weather.tempMin, context)),
                  Text(_showTemperature(state.weather.tempMax, context)),
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Spacer(),
              _showIcon(state.weather.icon),
              Expanded(
                flex: 3,
                child: formatText(state.weather.description),
              ),
              const Spacer(),
            ],
          )
        ],
      );
    }
  }), listener: ((context, state) {
    if (state.status == WeatherStatus.error) {
      errorDialog(context, state.error.errMsg);
    }
  }));
}
