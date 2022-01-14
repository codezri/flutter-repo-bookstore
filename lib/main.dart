import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repo_bookstore/controllers/home.dart';
import 'package:repo_bookstore/models/book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final HomeController _homeController = HomeController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Repo Book Store'),
        ),
        body: ListView(
          children: [_createForm(), _createDataTable()],
        ),
      ),
    );
  }

  Form _createForm() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _titleFieldController = TextEditingController();
    final TextEditingController _yearFieldController = TextEditingController();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleFieldController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _yearFieldController,
              decoration: const InputDecoration(
                labelText: 'Year',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter released year';
                }
                return null;
              },
            ),
            Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _homeController.addBook(Book(
                          10,
                          _titleFieldController.text,
                          int.parse(_yearFieldController.text)));
                      setState(() {});
                    }
                  },
                  child: Text('Add book'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _createDataTable() {
    return FutureBuilder<List<Book>>(
        future: _homeController.getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            return DataTable(
                columns: _createColumns(),
                rows: _createRows(snapshot.data ?? []));
          }
        });
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Book')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createRows(List<Book> books) {
    return books
        .map((book) => DataRow(cells: [
              DataCell(Text('#' + book.id.toString())),
              DataCell(Text('${book.title} (${book.year.toString()})')),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _homeController.removeBook(book.id);
                  setState(() {});
                },
              )),
            ]))
        .toList();
  }
}

