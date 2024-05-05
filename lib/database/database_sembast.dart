
import 'package:foodryp/database/database_interface';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:foodryp/models/celebration_day.dart';

class DatabaseSembast implements DatabaseInterface {
  static const String dbName = 'foodryp_database.db';
  Database? _database;
  final store = intMapStoreFactory.store('celebrations');

  @override
  Future<void> init() async {
    if (_database != null) return;
    const dbPath = 'foodryp_database.db'; // Use a different path for web
    _database = await databaseFactoryWeb.openDatabase(dbPath);
  }

  @override
  Future<int> insertCelebration(CelebrationDay celebration) async {
    await init();
    return await store.add(_database!, celebration.toMap());
  }

  @override
  Future<List<CelebrationDay>> queryAllCelebrations() async {
    await init();
    final finder = Finder(sortOrders: [SortOrder('dueDate')]);
    final recordSnapshots = await store.find(_database!, finder: finder);
    return recordSnapshots.map((snapshot) {
      final celebration = CelebrationDay.fromMap(snapshot.value);
      return celebration.copyWith(id: snapshot.key);
    }).toList();
  }

  @override
  Future<int> updateCelebration(CelebrationDay celebration) async {
    await init();
    final finder = Finder(filter: Filter.byKey(celebration.id));
    return await store.update(
      _database!,
      celebration.toMap(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteCelebration(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await store.delete(_database!, finder: finder);
  }

  
}
