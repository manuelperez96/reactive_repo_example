part of 'add_municipality_bloc.dart';

sealed class AddMunicipalityEvent extends Equatable {
  const AddMunicipalityEvent();

  @override
  List<Object> get props => [];
}

final class AddMunicipalityListLoaded extends AddMunicipalityEvent {}

final class AddMunicipalityMunicipalitySelected extends AddMunicipalityEvent {
  const AddMunicipalityMunicipalitySelected({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
