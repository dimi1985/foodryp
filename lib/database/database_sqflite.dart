import 'package:foodryp/database/database_interface';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/celebration_day.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseSqflite implements DatabaseInterface {
  //For Celbrate days

  static const table = 'celebrations';
  static const columnId = 'id';
  static const columnDescription = 'description';
  static const columnDueDate = 'dueDate';

  // For Categories
  static const String categoryTable = 'categories';
  static const String categoryId = 'id';
  static const String categoryName = 'name';
  static const String categoryFont = 'font';
  static const String categoryColor = 'color';
  static const String categoryRecipes = 'recipes'; // Store as JSON string

// For Recipes
  static const String recipeTable = 'recipes';
  static const String recipeId = 'id';
  static const String recipeTitle = 'recipeTitle';
  static const String recipeImage = 'recipeImage';
  static const String recipeIngredients = 'ingredients'; // Store as JSON string
  static const String recipeInstructions =
      'instructions'; // Store as JSON string
  static const String recipePrepDuration = 'prepDuration';
  static const String recipeCookDuration = 'cookDuration';
  static const String recipeServingNumber = 'servingNumber';
  static const String recipeDifficulty = 'difficulty';
  static const String recipeUsername = 'username';
  static const String recipeUseImage = 'useImage';
  static const String recipeUserId = 'userId';
  static const String recipeDateCreated = 'dateCreated';
  static const String recipeDescription = 'description';
  static const String recipeCategoryId = 'categoryId';
  static const String recipeCategoryColor = 'categoryColor';
  static const String recipeCategoryFont = 'categoryFont';
  static const String recipeCategoryName = 'categoryName';
  static const String recipeLikedBy = 'likedBy'; // Store as JSON string
  static const String recipeMeal = 'meal'; // Store as JSON string

// For Comments
  static const String commentTable = 'comments';
  static const String commentId = 'id';
  static const String commentText = 'text';
  static const String commentUserId = 'userId';
  static const String commentUsername = 'username';
  static const String commentUseImage = 'useImage';
  static const String commentRecipeId = 'recipeId';
  static const String commentDateCreated = 'dateCreated';
  static const String commentDateUpdated = 'dateUpdated';
  static const String commentReplies = 'replies'; // Store as JSON string

// For Users
  static const String userTable = 'users';
  static const String userId = 'id';
  static const String userUsername = 'username';
  static const String userEmail = 'email';
  static const String userProfileImage = 'profileImage';
  static const String userGender = 'gender';
  static const String userMemberSince = 'memberSince';
  static const String userRole = 'role';
  static const String userRecipes = 'recipes'; // Store as JSON string
  static const String userLikedRecipes = 'likedRecipes'; // Store as JSON string
  static const String userFollowers = 'followers'; // Store as JSON string
  static const String userFollowing = 'following'; // Store as JSON string
  static const String userFollowRequestsSent =
      'followRequestsSent'; // Store as JSON string
  static const String userFollowRequestsReceived =
      'followRequestsReceived'; // Store as JSON string
  static const String userFollowRequestsCanceled =
      'followRequestsCanceled'; // Store as JSON string

  static Database? _database;

  @override
  Future<void> init() async {
    if (_database != null) return;
    final path = await getDatabasesPath();
    final databasePath = join(path, 'foodryp_database.db');
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        // Create tables here
        await _createCelebrationTable(db);
        await _createCategoryTable(db);
        await _createRecipeTable(db);
        await _createCommentTable(db);
        await _createUserTable(db);
      },
    );
  }

//For Celebrate table
  Future<void> _createCelebrationTable(Database db) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDescription TEXT NOT NULL,
        $columnDueDate TEXT NOT NULL
      )
    ''');
  }

//For categoryTable
  Future<void> _createCategoryTable(Database db) async {
    await db.execute('''
      CREATE TABLE $categoryTable (
        $categoryId TEXT PRIMARY KEY,
        $categoryName TEXT NOT NULL,
        $categoryFont TEXT NOT NULL,
        $categoryColor TEXT NOT NULL,
        $categoryRecipes TEXT
      )
    ''');
  }

//For recipeTable
  Future<void> _createRecipeTable(Database db) async {
    await db.execute('''
      CREATE TABLE $recipeTable (
        $recipeId TEXT PRIMARY KEY,
        $recipeTitle TEXT NOT NULL,
        $recipeImage TEXT NOT NULL,
        $recipeIngredients TEXT NOT NULL,
        $recipeInstructions TEXT NOT NULL,
        $recipePrepDuration TEXT NOT NULL,
        $recipeCookDuration TEXT NOT NULL,
        $recipeServingNumber TEXT NOT NULL,
        $recipeDifficulty TEXT NOT NULL,
        $recipeUsername TEXT NOT NULL,
        $recipeUseImage TEXT,
        $recipeUserId TEXT NOT NULL,
        $recipeDateCreated TEXT NOT NULL,
        $recipeDescription TEXT NOT NULL,
        $recipeCategoryId TEXT NOT NULL,
        $recipeCategoryColor TEXT NOT NULL,
        $recipeCategoryFont TEXT NOT NULL,
        $recipeCategoryName TEXT NOT NULL,
        $recipeLikedBy TEXT,
        $recipeMeal TEXT
      )
    ''');
  }

//For commentTable
  Future<void> _createCommentTable(Database db) async {
    await db.execute('''
      CREATE TABLE $commentTable (
        $commentId TEXT PRIMARY KEY,
        $commentText TEXT NOT NULL,
        $commentUserId TEXT NOT NULL,
        $commentUsername TEXT NOT NULL,
        $commentUseImage TEXT NOT NULL,
        $commentRecipeId TEXT NOT NULL,
        $commentDateCreated TEXT NOT NULL,
        $commentDateUpdated TEXT,
        $commentReplies TEXT
      )
    ''');
  }

//For userTable
  Future<void> _createUserTable(Database db) async {
    await db.execute('''
      CREATE TABLE $userTable (
        $userId TEXT PRIMARY KEY,
        $userUsername TEXT NOT NULL,
        $userEmail TEXT NOT NULL,
        $userProfileImage TEXT NOT NULL,
        $userGender TEXT,
        $userMemberSince TEXT,
        $userRole TEXT,
        $userRecipes TEXT,
        $userLikedRecipes TEXT,
        $userFollowers TEXT,
        $userFollowing TEXT,
        $userFollowRequestsSent TEXT,
        $userFollowRequestsReceived TEXT,
        $userFollowRequestsCanceled TEXT
      )
    ''');
  }

//For Celebrate days
  @override
  Future<int> insertCelebration(CelebrationDay celebration) async {
    Database db = await database;
    return await db.insert(table, celebration.toMap());
  }

  @override
  Future<List<CelebrationDay>> queryAllCelebrations() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return CelebrationDay.fromMap(maps[i]);
    });
  }

  @override
  Future<int> updateCelebration(CelebrationDay celebration) async {
    Database db = await database;
    return await db.update(table, celebration.toMap(),
        where: '$columnId = ?', whereArgs: [celebration.id]);
  }

  @override
  Future<int> deleteCelebration(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await init(); // Ensure database is initialized
    return _database!;
  }

  //For Categories
  Future<int> insertCategory(CategoryModel category) async {
    final db = await _database;
    return await db!.insert(categoryTable, category.toJson());
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db!.query(categoryTable);
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  Future<int> updateCategory(CategoryModel category) async {
    final db = await _database;
    return await db!.update(
      categoryTable,
      category.toJson(),
      where: '$categoryId = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(String id) async {
    final db = await _database;
    return await db!.delete(
      categoryTable,
      where: '$categoryId = ?',
      whereArgs: [id],
    );
  }

  //For Recipes

  Future<int> insertRecipe(Recipe recipe) async {
    final db = await _database;
    return await db!.insert(recipeTable, recipe.toJson());
  }

  Future<List<Recipe>> getAllRecipes() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db!.query(recipeTable);
    return List.generate(maps.length, (i) {
      return Recipe.fromJson(maps[i]);
    });
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final db = await _database;
    return await db!.update(
      recipeTable,
      recipe.toJson(),
      where: '$recipeId = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<int> deleteRecipe(String id) async {
    final db = await _database;
    return await db!.delete(
      recipeTable,
      where: '$recipeId = ?',
      whereArgs: [id],
    );
  }

  //For Comments

  Future<int> insertComment(Comment comment) async {
    final db = await _database;
    return await db!.insert(commentTable, comment.toJson());
  }

  Future<List<Comment>> getAllComments() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db!.query(commentTable);
    return List.generate(maps.length, (i) {
      return Comment.fromJson(maps[i]);
    });
  }

  Future<int> updateComment(Comment comment) async {
    final db = await _database;
    return await db!.update(
      commentTable,
      comment.toJson(),
      where: '$commentId = ?',
      whereArgs: [comment.id],
    );
  }

  Future<int> deleteComment(String id) async {
    final db = await _database;
    return await db!.delete(
      commentTable,
      where: '$commentId = ?',
      whereArgs: [id],
    );
  }

  //For Users

  Future<int> insertUser(User user) async {
  final db = await _database;
  return await db!.insert(userTable, user.toJson());
}

Future<List<User>> getAllUsers() async {
  final db = await _database;
  final List<Map<String, dynamic>> maps = await db!.query(userTable);
  return List.generate(maps.length, (i) {
    return User.fromJson(maps[i]);
  });
}

Future<int> updateUser(User user) async {
  final db = await _database;
  return await db!.update(
    userTable,
    user.toJson(),
    where: '$userId = ?',
    whereArgs: [user.id],
  );
}

Future<int> deleteUser(String id) async {
  final db = await _database;
  return await db!.delete(
    userTable,
    where: '$userId = ?',
    whereArgs: [id],
  );
}

}
