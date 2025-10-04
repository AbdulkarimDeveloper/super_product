import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_project/core/secure_storage_abs.dart';

class SecureStorageImpl<T> extends SecureStorageAbs<T> {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  @override
  Future<bool> add(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
  ) async {
    final data = await storage.read(key: key);

    List<T> items = data == null ? [] : parseFromString(data);
    items.add(item);

    await storage.write(key: key, value: parseToString(items));
    return true;
  }

  @override
  Future<bool> update(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
    dynamic Function(T item) compareTo,
  ) async {
    final data = await storage.read(key: key);
    if (data == null) {
      return false;
    }

    List<T> items = parseFromString(data);
    int index = items.indexWhere(
      (element) => compareTo(element) == compareTo(item),
    );
    if (index <= -1) {
      return false;
    }

    items[index] = item;
    await storage.write(key: key, value: parseToString(items));

    return true;
  }

  @override
  Future<bool> delete(
    String key,
    T item,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
    dynamic Function(T item) compareTo,
  ) async {
    final data = await storage.read(key: key);
    if (data == null) {
      return false;
    }

    List<T> items = parseFromString(data);
    int index = items.indexWhere(
      (element) => compareTo(element) == compareTo(item),
    );
    if (index <= -1) {
      return false;
    }

    items.removeAt(index);
    await storage.write(key: key, value: parseToString(items));

    return true;
  }

  @override
  Future<List<T>> getAll(
    String key,
    List<T> Function(String data) parseFromString,
  ) async {
    final data = await storage.read(key: key);
    if (data == null) {
      return [];
    }

    List<T> items = parseFromString(data);
    return items;
  }

  @override
  Future<bool> addAll(
    String key,
    List<T> items,
    List<T> Function(String data) parseFromString,
    String Function(List<T> list) parseToString,
  ) async {
    final data = await storage.read(key: key);

    List<T> oldItems = data == null ? [] : parseFromString(data);
    oldItems.addAll(items);

    await storage.write(key: key, value: parseToString(oldItems));

    return true;
  }
}
