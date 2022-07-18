import 'dart:collection';

class Stack<T> {
  late final Queue<T> buffer;

  Stack() {
    buffer = Queue();
  }

  Stack.from(Iterable<dynamic> elements) {
    buffer = Queue.from(elements);
  }

  T? get top => buffer.isEmpty ? null : buffer.last;
  bool get isEmpty => buffer.isEmpty;
  bool get isNotEmpty => buffer.isNotEmpty;

  void push(T v) => buffer.addLast(v);
  T? pop() => buffer.isEmpty ? null : buffer.removeLast();

  @override
  String toString() => '$buffer';
}
