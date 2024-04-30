import 'package:reactive_repo_example/domain/municipality.dart';

abstract interface class MunicipalitiesRepository {
  Future<void> fetchMunicipalities();
  Stream<List<Municipality>> getMunicipalities();
  Future<void> toggleFavorite(String municipalityId);
}
