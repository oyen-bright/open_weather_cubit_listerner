import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/cubits/tempsettings/tempsettings_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: ListTile(
          title: const Text('Temperature Unit'),
          subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
          trailing: Switch(
            value: context.watch<TempsettingsCubit>().state.tempunit ==
                TempUnit.celsius,
            onChanged: (_) {
              context.read<TempsettingsCubit>().toggleTemp();
            },
          ),
        ),
      ),
    );
  }
}
