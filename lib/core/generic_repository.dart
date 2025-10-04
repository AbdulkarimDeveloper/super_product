abstract class GenericRepository<T> {
  Future<bool> add(T item);

  Future<bool> update(T item);

  Future<bool> delete(T item);

  Future<bool> addAll(List<T> items);

  Future<List<T>> getAll();
}
