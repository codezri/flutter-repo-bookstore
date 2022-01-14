class VirtualDB {
  List<Map<String, dynamic>> items = [];
  static final VirtualDB _db = VirtualDB._privateConstructor();

  VirtualDB._privateConstructor();

  factory VirtualDB() {
    return _db;
  }

  Future<void> insert(Map<String, dynamic> item) async {
    items.add(item);
  }

  Future<void> remove(int id) async {
    items.removeWhere((item) => item['id'] == id);
  }

  Future<void> update(Map<String, dynamic> updatedItem) async {
    int i = items.indexWhere((item) => item['id'] == updatedItem['id']);
    items[i] = updatedItem;
  }

  Future<List<Map<String, dynamic>>> list() async {
    await Future.delayed(Duration(milliseconds: 500));
    return items;
  }

  Future<Map<String, dynamic>?> findOne(int id) async {
    return items.firstWhere((item) => item['id'] == id);
  }
}