import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tempsettings_state.dart';

class TempsettingsCubit extends Cubit<TempsettingsState> {
  TempsettingsCubit() : super(const TempsettingsState());

  void toggleTemp() {
    emit(state.copyWith(
        tempunit: state.tempunit == TempUnit.celsius
            ? TempUnit.fahrenheit
            : TempUnit.celsius));
  }
}
