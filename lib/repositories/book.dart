import 'package:repo_bookstore/db/virtual_db.dart';
import 'package:repo_bookstore/repositories/book_interface.dart';
import 'package:repo_bookstore/models/book.dart';

class BookRepository implements IBookRepository {

  final VirtualDB _db;

  BookRepository(this._db);

  @override
  Future<List<Book>> getAll() async {
    var items = await _db.list();
    return items.map((item) => Book.fromMap(item)).toList();
  }

  @override
  Future<Book?> getOne(int id) async {
    var item = await _db.findOne(id);
    return item != null ? Book.fromMap(item) : null;
  }

  @override
  Future<void> insert(Book book) async {
    await _db.insert(book.toMap());
  }

  @override
  Future<void> update(Book book) async {
    await _db.update(book.toMap());
  }

  @override
  Future<void> delete(int id) async {
    await _db.remove(id);
  }
}
