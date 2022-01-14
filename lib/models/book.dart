class Book {
  late int id;
  late String title;
  late int year;

  Book(this.id, this.title, this.year);

  Book.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    year = data['year'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year
    };
  }
}
