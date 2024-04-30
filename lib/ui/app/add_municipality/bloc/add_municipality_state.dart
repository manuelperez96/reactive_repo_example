part of 'add_municipality_bloc.dart';

class AddMunicipalityState extends Equatable {
  const AddMunicipalityState({
    this.municipality = const <Municipality>[],
  });

  final List<Municipality> municipality;

  List<Municipality> get noFavoriteMunicipality =>
      municipality.where((element) => !element.isFavorite).toList();

  @override
  List<Object> get props => [municipality];
}
