import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_repo_example/data/online_municipalities_repository.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required MunicipalitiesRepository municipalitiesRepository,
  })  : _municipalitiesRepository = municipalitiesRepository,
        super(const AppState()) {
    on<AppDataFetched>(_onDataFetched);
  }

  final MunicipalitiesRepository _municipalitiesRepository;

  Future<void> _onDataFetched(
    AppDataFetched event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _municipalitiesRepository.fetchMunicipalities();
      emit(const AppState.load());
    } on FetchMunicipalitiesException catch (e, s) {
      addError(e, s);
      emit(const AppState.error());
    }
  }
}
