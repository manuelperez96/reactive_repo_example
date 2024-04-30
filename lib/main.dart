import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_repo_example/data/cache.dart';
import 'package:reactive_repo_example/data/municipalities_client.dart';
import 'package:reactive_repo_example/data/online_municipalities_repository.dart';
import 'package:reactive_repo_example/data/reactive_storage.dart';
import 'package:reactive_repo_example/domain/municipalities_base.dart';
import 'package:reactive_repo_example/domain/municipalities_repository.dart';
import 'package:reactive_repo_example/ui/app/bloc/app_bloc.dart';
import 'package:reactive_repo_example/ui/home/home_screen.dart';
import 'package:reactive_repo_example/ui/splash_error_screen.dart';
import 'package:reactive_repo_example/ui/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  final dio = _getDio();
  final cache = TemporalCache<MunicipalityBase>();
  final client = DioMinicipalitiesClient(dio: dio);
  final reactiveStorage = LocalReactiveStorage(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
  final municipalitiesRepository = OnlineMunicipalitiesRepository(
    municipalityCache: cache,
    municipalitiesClient: client,
    reactiveStorage: reactiveStorage,
  );

  runApp(MyApp(municipalitiesRepository: municipalitiesRepository));
}

Dio _getDio() {
  final baseOptons = BaseOptions(
    baseUrl: 'https://private-anon-4eae925aa1-meteocat.apiary-mock.com',
  );

  return Dio(baseOptons);
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required MunicipalitiesRepository municipalitiesRepository,
  }) : _municipalitiesRepository = municipalitiesRepository;

  final MunicipalitiesRepository _municipalitiesRepository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _key = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _key.currentState!;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: widget._municipalitiesRepository,
      child: BlocProvider(
        create: (_) => AppBloc(
          municipalitiesRepository: widget._municipalitiesRepository,
        ),
        child: MaterialApp(
          title: 'Reactive Repo Example',
          navigatorKey: _key,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
          builder: _addAuthListener,
        ),
      ),
    );
  }

  Widget _addAuthListener(BuildContext context, Widget? child) {
    return BlocListener<AppBloc, AppState>(
      listener: _navigateToMainPages,
      child: child,
    );
  }

  void _navigateToMainPages(BuildContext context, AppState state) {
    switch (state.status) {
      case AppStatus.loading:
        _pushRoute(const SplashScreen());
      case AppStatus.error:
        _pushRoute(const SplashErrorScreen());
      case AppStatus.loaded:
        _pushRoute(const HomeScreen());
    }
  }

  void _pushRoute(Widget route) {
    _navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => route),
      (route) => false,
    );
  }
}
