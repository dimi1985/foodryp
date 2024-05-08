import 'package:foodryp/database/database_interface';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:foodryp/models/celebration_day.dart';

class DatabaseSembast implements DatabaseInterface {
  static const String dbName = 'foodryp_database.db';
  Database? _database;
  final _store = intMapStoreFactory.store('celebrations');
  final _categoryStore = intMapStoreFactory.store('categories');
  final _recipeStore = intMapStoreFactory.store('recipes');
  final _commentStore = intMapStoreFactory.store('comments');
  final _userStore = intMapStoreFactory.store('users');
  final _weeklyMenuStore = intMapStoreFactory.store('weekly_menus');

  @override
  Future<void> init() async {
    if (_database != null) return;
    const dbPath = 'foodryp_database.db'; // Use a different path for web
    _database = await databaseFactoryWeb.openDatabase(dbPath);
  }

  @override
  Future<int> insertCelebration(CelebrationDay celebration) async {
    await init();
    return await _store.add(_database!, celebration.toMap());
  }

  @override
  Future<List<CelebrationDay>> queryAllCelebrations() async {
    await init();
    final finder = Finder(sortOrders: [SortOrder('dueDate')]);
    final recordSnapshots = await _store.find(_database!, finder: finder);
    return recordSnapshots.map((snapshot) {
      final celebration = CelebrationDay.fromMap(snapshot.value);
      return celebration.copyWith(id: snapshot.key);
    }).toList();
  }

  @override
  Future<int> updateCelebration(CelebrationDay celebration) async {
    await init();
    final finder = Finder(filter: Filter.byKey(celebration.id));
    return await _store.update(
      _database!,
      celebration.toMap(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteCelebration(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _store.delete(_database!, finder: finder);
  }

  //for categories
  @override
  Future<int> insertCategory(CategoryModel category) async {
    await init();
    return await _categoryStore.add(_database!, category.toJson());
  }

  @override
  Future<List<CategoryModel>> queryAllCategories() async {
    await init();
    final recordSnapshots = await _categoryStore.find(_database!);
    return recordSnapshots.map((snapshot) {
      final category = CategoryModel.fromJson(snapshot.value);
      return category;
    }).toList();
  }

  @override
  Future<int> updateCategory(CategoryModel category) async {
    await init();
    final finder = Finder(filter: Filter.byKey(category.id));
    return await _categoryStore.update(
      _database!,
      category.toJson(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteCategory(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _categoryStore.delete(_database!, finder: finder);
  }

  //for recipes
  @override
  Future<int> insertRecipe(Recipe recipe) async {
    await init();
    return await _recipeStore.add(_database!, recipe.toJson());
  }

  @override
  Future<List<Recipe>> queryAllRecipes() async {
    await init();
    final recordSnapshots = await _recipeStore.find(_database!);
    return recordSnapshots.map((snapshot) {
      final category = Recipe.fromJson(snapshot.value);
      return category;
    }).toList();
  }
@override
Future<List<Recipe>> queryTopThreeRecipes() async {
  await init();
  final finder = Finder(sortOrders: [SortOrder('likedBy', true)], limit: 3);
  final recordSnapshots = await _recipeStore.find(_database!, finder: finder);
  
  List<Recipe> topRecipes = [];
  for (var snapshot in recordSnapshots) {
    final recipe = Recipe.fromJson(snapshot.value);
    topRecipes.add(recipe);
  }

  return topRecipes;
}



  @override
  Future<int> updateRecipe(Recipe recipe) async {
    await init();
    final finder = Finder(filter: Filter.byKey(recipe.id));
    return await _recipeStore.update(
      _database!,
      recipe.toJson(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteRecipe(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _recipeStore.delete(_database!, finder: finder);
  }

  //for users
  @override
  Future<int> insertUser(User user) async {
    await init();
    return await _userStore.add(_database!, user.toJson());
  }

  @override
  Future<List<User>> queryAllUsers() async {
    await init();
    final recordSnapshots = await _userStore.find(_database!);
    return recordSnapshots.map((snapshot) {
      final user = User.fromJson(snapshot.value);
      return user;
    }).toList();
  }

  @override
  Future<int> updateUser(User user) async {
    await init();
    final finder = Finder(filter: Filter.byKey(user.id));
    return await _userStore.update(
      _database!,
      user.toJson(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteUser(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _userStore.delete(_database!, finder: finder);
  }
  //for comments

  @override
  Future<int> insertComment(Comment comment) async {
    await init();
    return await _userStore.add(_database!, comment.toJson());
  }

  @override
  Future<List<Comment>> queryAllComments() async {
    await init();
    final recordSnapshots = await _commentStore.find(_database!);
    return recordSnapshots.map((snapshot) {
      final comment = Comment.fromJson(snapshot.value);
      return comment;
    }).toList();
  }

  @override
  Future<int> updateComment(Comment comment) async {
    await init();
    final finder = Finder(filter: Filter.byKey(comment.id));
    return await _commentStore.update(
      _database!,
      comment.toJson(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteComment(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _commentStore.delete(_database!, finder: finder);
  }

  //for weekly menus
  @override
  Future<int> insertWeeklyMenu(WeeklyMenu weeklyMenu) async {
    await init();
    return await _weeklyMenuStore.add(_database!, weeklyMenu.toJson());
  }

  @override
  Future<List<WeeklyMenu>> queryAllWeeklyMenu() async {
    await init();
    final recordSnapshots = await _weeklyMenuStore.find(_database!);
    return recordSnapshots.map((snapshot) {
      final weeklyMenu = WeeklyMenu.fromJson(snapshot.value);
      return weeklyMenu;
    }).toList();
  }

  @override
  Future<int> updateWeeklyMenu(WeeklyMenu weeklyMenu) async {
    await init();
    final finder = Finder(filter: Filter.byKey(weeklyMenu.id));
    return await _weeklyMenuStore.update(
      _database!,
      weeklyMenu.toJson(),
      finder: finder,
    );
  }

  @override
  Future<int> deleteWeeklyMenu(int id) async {
    await init();
    final finder = Finder(filter: Filter.byKey(id));
    return await _weeklyMenuStore.delete(_database!, finder: finder);
  }
}
