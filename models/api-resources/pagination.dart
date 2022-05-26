class PaginationMetaData {
  PaginationMetaData({required this.currentPage, required this.total, required this.lastPage});

  final int currentPage;
  final int total;
  final int lastPage;

  static PaginationMetaData fromJson(dynamic content) {
    return PaginationMetaData(
        currentPage: content['current_page'],
        total: content['total'],
        lastPage: content['last_page']);
  }
}

class PaginationLinks {
  PaginationLinks({required this.first, required this.last, required this.prev, required this.next});

  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  static PaginationLinks fromJson(dynamic content) {
    return PaginationLinks(
        first: content['first'],
        last: content['last'],
        prev: content['prev'],
        next: content['next']);
  }
}
