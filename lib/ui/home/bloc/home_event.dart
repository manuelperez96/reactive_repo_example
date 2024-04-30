part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomeSubscriptionRequest extends HomeEvent {}

final class HomeFavoriteRemoved extends HomeEvent {
  const HomeFavoriteRemoved({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
