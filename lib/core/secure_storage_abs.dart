abstract class SecureStorageAbs<T> {
  Future<bool> add(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
  );
  Future<bool> update(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
    dynamic Function(T item) compareTo,
  );
  Future<bool> delete(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
    dynamic Function(T item) compareTo,
  );
  Future<List<T>> getAll(
    String key,
    List<T> Function(String data) parseFromString,
  );
  Future<bool> addAll(
    String key,
    List<T> items,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
  );
}
