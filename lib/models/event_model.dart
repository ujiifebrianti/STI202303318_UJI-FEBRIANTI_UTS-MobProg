class Event {
  final String title;
  final String category;
  final DateTime dateTime; // gunakan DateTime biar bisa diatur otomatis
  final String description;

  Event({
    required this.title,
    required this.category,
    required this.dateTime,
    this.description = '',
  });
}
