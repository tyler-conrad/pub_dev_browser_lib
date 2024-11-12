/// Extension on [Iterable] to intersperse elements between each element.
///
/// This extension is used in the `SegmentedButtons` widget to separate each
/// child with a vertical line. Accepts the optional parameters `beforeFirst`
/// and `afterLast` to determine if the separator should be added before the
/// first element and after the last element.
extension X<T> on Iterable<T> {
  Iterable<T> intersperse(T separator,
      {bool beforeFirst = false, bool afterLast = false}) sync* {
    bool empty = true;
    for (final e in this) {
      if (!empty || beforeFirst) yield separator;
      empty = false;
      yield e;
    }
    if (!empty && afterLast) yield separator;
  }
}
