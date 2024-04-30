part of 'app_bloc.dart';

enum AppStatus { loading, error, loaded }

class AppState extends Equatable {
  const AppState({this.status = AppStatus.loading});
  const AppState.error() : this(status: AppStatus.error);
  const AppState.load() : this(status: AppStatus.loaded);

  final AppStatus status;

  @override
  List<Object> get props => [status];
}
