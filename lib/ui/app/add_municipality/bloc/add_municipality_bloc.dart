import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/domain/municipality.dart';

part 'add_municipality_event.dart';
part 'add_municipality_state.dart';

class AddMunicipalityBloc
    extends Bloc<AddMunicipalityEvent, AddMunicipalityState> {
  AddMunicipalityBloc({
    required MunicipalitiesRepository municipalitiesRepository,
  })  : _municipalitiesRepository = municipalitiesRepository,
        super(const AddMunicipalityState()) {
    on<AddMunicipalityListLoaded>(_onAddMunicipalityListLoaded);
    on<AddMunicipalityMunicipalitySelected>(
      _onAddMunicipalityMunicipalitySelected,
    );
  }

  final MunicipalitiesRepository _municipalitiesRepository;

  Future<void> _onAddMunicipalityListLoaded(
    AddMunicipalityListLoaded event,
    Emitter<AddMunicipalityState> emit,
  ) async {
    final list = await _municipalitiesRepository.getMunicipalities().first;
    emit(AddMunicipalityState(municipality: list));
  }

  void _onAddMunicipalityMunicipalitySelected(
    AddMunicipalityMunicipalitySelected event,
    Emitter<AddMunicipalityState> emit,
  ) {
    _municipalitiesRepository.toggleFavorite(event.id);
  }
}
