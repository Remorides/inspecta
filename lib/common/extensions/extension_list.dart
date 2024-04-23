/// Extend functions of List<T>
extension ListExtensions<T> on List<T> {
  List<T> separateWith(
    T splitter, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) =>
      <T>[
        if (alsoFirst || alsoFirstAndLast) splitter,
        if (isNotEmpty) first,
        for (int i = 1; i < length; ++i) ...<T>[
          splitter,
          this[i],
        ],
        if (alsoLast || alsoFirstAndLast) splitter,
      ];

  List<T> separateWithMultiple(
    Iterable<T> splitters, {
    bool alsoFirst = false,
    bool alsoLast = false,
    bool alsoFirstAndLast = false,
  }) =>
      <T>[
        if (alsoFirst || alsoFirstAndLast) ...splitters,
        if (isNotEmpty) first,
        for (int i = 1; i < length; ++i) ...<T>[...splitters, this[i]],
        if (alsoLast || alsoFirstAndLast) ...splitters,
      ];

  Iterable<List<T>?> part(int size) =>
      (isEmpty ? <List<T>>[] : _Partition<T>(this, size)) as Iterable<List<T>?>;

  List<T> pad(int len, {required T e}) => <T>[
        for (int i = 0; i < len; ++i)
          if (length > i) this[i] else e,
      ];

  List<T> addItemInBetween(T item) => length <= 1
      ? this
      : sublist(1).fold(
          <T>[first],
          (List<T> r, T element) => <T>[...r, item, element],
        );

  List<T> withoutNull(List<T?> widgets) {
    return List<T>.from(
      widgets..removeWhere((T? t) => t == null),
    );
  }
}

class _Partition<T> extends Iterable<List<T>?> {
  _Partition(this._iterable, this._size) {
    if (_size <= 0) throw ArgumentError(_size);
  }

  final Iterable<T> _iterable;
  final int _size;

  @override
  Iterator<List<T>?> get iterator => _PartitionIterator<T>(
        _iterable.iterator,
        _size,
      );
}

class _PartitionIterator<T> implements Iterator<List<T>?> {
  _PartitionIterator(this._iterator, this._size);

  final Iterator<T> _iterator;
  final int _size;
  List<T>? _current;

  @override
  List<T>? get current => _current;

  @override
  bool moveNext() {
    final newValue = <T>[];
    var count = 0;
    while (count < _size && _iterator.moveNext()) {
      newValue.add(_iterator.current);
      count++;
    }
    _current = (count > 0) ? newValue : null;
    return _current != null;
  }
}
