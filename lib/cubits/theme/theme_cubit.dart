import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:open_weather_cubit/models/weather.dart';

import '../../constants/constants.dart';
import '../weather/weather_cubit.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());
  void checkTeme(Weather weather) {
    if (weather.temp > kWarmOrNot) {
      emit(state.copyWith(appTheme: AppTheme.light));
    } else {
      emit(state.copyWith(appTheme: AppTheme.dark));
    }
  }
}
