import 'package:reactive_repo_example/domain/municipalities_base.dart';

class Municipality extends MunicipalityBase {
  const Municipality({
    required super.id,
    required super.name,
    required this.isFavorite,
  });

  final bool isFavorite;

  @override
  List<Object?> get props => [id, name, isFavorite];
}
