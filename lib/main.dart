import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repo_bookstore/controllers/home.dart';
import 'package:repo_bookstore/models/book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Repo Book Store'),
          ),
          body: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  final HomeController _homeController = HomeController();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _Form(widget._homeController, _refreshList),
      _BookTable(widget._homeController, _refreshList)
    ]);
  }
}

class _Form extends StatefulWidget {
  final HomeController _homeController;
  final VoidCallback _refreshList;

  _Form(this._homeController, this._refreshList);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _yearFieldController = TextEditingController();

  @override
  void dispose() {
    _titleFieldController.dispose();
    _yearFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      await widget._homeController.addBook(Book(
                          0,
                          _titleFieldController.text,
                          int.parse(_yearFieldController.text)));
                      _titleFieldController.clear();
                      _yearFieldController.clear();
                      widget._refreshList();
                    }
                  },
                  child: Text('Add book'),
                )),
          ],
        ),
      ),
    );
  }
}

class _BookTable extends StatelessWidget {
  final HomeController _homeController;
  final VoidCallback _refreshList;

  _BookTable(this._homeController, this._refreshList);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
        future: _homeController.getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('Loading..'));
          } else {
            return DataTable(
                columns: _createBookTableColumns(),
                rows: _createBookTableRows(snapshot.data ?? []));
          }
        });
  }

  List<DataColumn> _createBookTableColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Book')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createBookTableRows(List<Book> books) {
    return books
        .map((book) => DataRow(cells: [
              DataCell(Text('#' + book.id.toString())),
              DataCell(Text('${book.title} (${book.year.toString()})')),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _homeController.removeBook(book.id);
                  _refreshList();
                },
              )),
            ]))
        .toList();
  }
}
