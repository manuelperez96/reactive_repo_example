import 'package:dio/dio.dart';

class GetMunicipalityException implements Exception {}

abstract interface class MunicipalitiesClient {
  Future<List<Map<String, dynamic>>> getAllMunicipalities();
}

class DioMinicipalitiesClient implements MunicipalitiesClient {
  const DioMinicipalitiesClient({required Dio dio}) : _dio = dio;

  final Dio _dio;

  static const _municipalityUrl = '/geo/municipis.json';

  @override
  Future<List<Map<String, dynamic>>> getAllMunicipalities() async {
    try {
      final response = await _dio.get<List>(_municipalityUrl);
      if (response.statusCode != 200 ||
          response.data == null ||
          response.data!.isEmpty) {
        throw GetMunicipalityException();
      }
      return response.data!.cast<Map<String, dynamic>>();
    } catch (e) {
      throw GetMunicipalityException();
    }
  }
}
