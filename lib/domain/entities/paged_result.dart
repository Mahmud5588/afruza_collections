class PagedResult<T> {
  const PagedResult({
    required this.items,
    required this.total,
    required this.skip,
    required this.limit,
    required this.nextSkip,
  });

  final List<T> items;
  final int total;
  final int skip;
  final int limit;
  final int? nextSkip;
}
