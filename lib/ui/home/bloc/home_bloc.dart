import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/domain/municipality.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required MunicipalitiesRepository municipalitiesRepository,
  })  : _municipalitiesRepository = municipalitiesRepository,
        super(const HomeState.initial()) {
    on<HomeSubscriptionRequest>(_onHomeSubscriptionRequest);
    on<HomeFavoriteRemoved>(_onHomeFavoriteRemoved);
  }

  final MunicipalitiesRepository _municipalitiesRepository;

  Future<void> _onHomeSubscriptionRequest(
    HomeSubscriptionRequest event,
    Emitter<HomeState> emit,
  ) async {
    await emit.forEach(
      _municipalitiesRepository.getMunicipalities(),
      onData: _onData,
    );
  }

  void _onHomeFavoriteRemoved(
    HomeFavoriteRemoved event,
    Emitter<HomeState> emit,
  ) {
    _municipalitiesRepository.toggleFavorite(event.id);
  }

  HomeState _onData(List<Municipality> municipality) =>
      HomeState.load(municipality: municipality);
}
