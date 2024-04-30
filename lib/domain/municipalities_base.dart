import 'package:equatable/equatable.dart';

class MunicipalityBase extends Equatable {
  const MunicipalityBase({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}
