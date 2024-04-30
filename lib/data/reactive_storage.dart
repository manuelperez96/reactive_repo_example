import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ReactiveStorage<T> {
  Stream<List<T>> get getValues;
  Future<void> toggleFavorite(T value);
  Future<void> close();
}

class LocalReactiveStorage implements ReactiveStorage<String> {
  LocalReactiveStorage({required SharedPreferences sharedPreferences})
      : _plugin = sharedPreferences {
    _init();
  }

  final SharedPreferences _plugin;

  late final _idStreamController = BehaviorSubject<List<String>>.seeded(
    const [],
  );

  void _init() {
    final favoriteIds = _getValues(favoriteIdsKey);
    if (favoriteIds != null && favoriteIds.isNotEmpty) {
      _idStreamController.add(favoriteIds);
    } else {
      _idStreamController.add(const []);
    }
  }

  @visibleForTesting
  static const favoriteIdsKey = '__todos_collection_key__';

  List<String>? _getValues(String key) => _plugin.getStringList(key);
  Future<void> _setValues(String key, List<String> values) =>
      _plugin.setStringList(key, values);

  @override
  Future<void> toggleFavorite(String value) async {
    final values = [..._idStreamController.value];
    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }

    _idStreamController.add(values);
    _setValues(favoriteIdsKey, values);
  }

  @override
  Stream<List<String>> get getValues => _idStreamController.asBroadcastStream();

  @override
  Future<void> close() {
    return _idStreamController.close();
  }
}
