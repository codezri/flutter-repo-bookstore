import 'dart:math';
import 'package:repo_bookstore/db/virtual_db.dart';
import 'package:repo_bookstore/repositories/book.dart';
import 'package:repo_bookstore/models/book.dart';

class HomeController {
  BookRepository _bookRepo = BookRepository(VirtualDB());

  Future<List<Book>> getAllBooks() {
    return _bookRepo.getAll();
  }

  Future<void> addBook(Book book) {
    book.id = Random().nextInt(100);
    return _bookRepo.insert(book);
  }

  Future<void> removeBook(int id) {
    return _bookRepo.delete(id);
  }
}
