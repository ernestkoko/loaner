///an abstract class that takes a generic type [T] and has two methods
///[fromMap] that takes a map and returns the generic type [T] and
///[toMap] that returns a map
abstract class WriteRead<T> {
  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();
}
