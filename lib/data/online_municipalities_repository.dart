import 'package:reactive_repo_example/data/cache.dart';
import 'package:reactive_repo_example/data/reactive_storage.dart';
import 'package:reactive_repo_example/domain/municipalities_base.dart';
import 'package:reactive_repo_example/data/municipalities_client.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/domain/municipality.dart';

class FetchMunicipalitiesException implements Exception {}

class OnlineMunicipalitiesRepository implements MunicipalitiesRepository {
  const OnlineMunicipalitiesRepository({
    required Cache<MunicipalityBase> municipalityCache,
    required MunicipalitiesClient municipalitiesClient,
    required ReactiveStorage<String> reactiveStorage,
  })  : _municipalitiesClient = municipalitiesClient,
        _municipalityCache = municipalityCache,
        _reactiveStorage = reactiveStorage;

  final Cache<MunicipalityBase> _municipalityCache;
  final MunicipalitiesClient _municipalitiesClient;
  final ReactiveStorage<String> _reactiveStorage;

  @override
  Future<void> fetchMunicipalities() async {
    try {
      final data = (await _municipalitiesClient.getAllMunicipalities())
          .map((e) => e.toMunicipalityBase())
          .toList();
      _municipalityCache.saveValues(data);
    } on GetMunicipalityException {
      throw FetchMunicipalitiesException();
    }
  }

  @override
  Stream<List<Municipality>> getMunicipalities() {
    return _reactiveStorage.getValues.map(
      (favoriteIds) {
        return _municipalityCache.getValues
            .map(
              (municipality) => Municipality(
                id: municipality.id,
                name: municipality.name,
                isFavorite: favoriteIds.contains(municipality.id),
              ),
            )
            .toList();
      },
    );
  }

  @override
  Future<void> toggleFavorite(String municipalityId) {
    return _reactiveStorage.toggleFavorite(municipalityId);
  }

  Future<void> close() {
    return _reactiveStorage.close();
  }
}

extension MunicipalityParser on Map<String, dynamic> {
  MunicipalityBase toMunicipalityBase() {
    return MunicipalityBase(
      id: this['codi'] as String,
      name: this['nom'] as String,
    );
  }
}
