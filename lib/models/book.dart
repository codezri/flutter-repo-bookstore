class Book {
  final int id;
  final String title;
  final int year;

  Book(this.id, this.title, this.year);

  Book.fromMap(Map<String, dynamic> data) :
    id = data['id'],
    title = data['title'],
    year = data['year'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year
    };
  }
}
