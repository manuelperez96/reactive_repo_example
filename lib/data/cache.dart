class NeedPrefetchDataException implements Exception {}

abstract interface class Cache<T> {
  void saveValues(List<T> values);
  List<T> get getValues;
}

class TemporalCache<T> implements Cache<T> {
  final _values = <T>[];
  var isPrefetch = false;

  @override
  List<T> get getValues {
    if (!isPrefetch) throw NeedPrefetchDataException();
    return _values;
  }

  @override
  void saveValues(List<T> values) {
    isPrefetch = true;
    _values.addAll(values);
  }
}
