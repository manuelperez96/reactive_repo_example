part of 'home_bloc.dart';

enum HomeStatus { loading, load }

class HomeState extends Equatable {
  const HomeState._({
    this.status = HomeStatus.loading,
    this.municipality = const <Municipality>[],
  });

  const HomeState.initial() : this._();
  const HomeState.load({
    required List<Municipality> municipality,
  }) : this._(municipality: municipality, status: HomeStatus.load);

  final HomeStatus status;
  final List<Municipality> municipality;

  List<Municipality> get favoriteMunicipalities =>
      municipality.where((element) => element.isFavorite).toList();

  @override
  List<Object> get props => [status, municipality];
}
