import 'package:foodryp/database/database_interface';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/celebration_day.dart';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/weeklyMenu.dart';
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

// For WeeklyMenu
  static const String weeklyMenuTable = 'weekly_menus';
  static const String weeklyMenuId = 'id';
  static const String weeklyMenuTitle = 'title';
  static const String weeklyMenuDayOfWeek = 'dayOfWeek'; // Store as JSON string
  static const String weeklyMenuUserId = 'userId';
  static const String weeklyMenuUsername = 'username';
  static const String weeklyMenuUserProfileImage = 'userProfileImage';
  static const String weeklyMenuDateCreated = 'dateCreated';

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
        await _createWeeklyMenuTable(db);
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

  // For weeklyMenuTable
  Future<void> _createWeeklyMenuTable(Database db) async {
    await db.execute('''
    CREATE TABLE $weeklyMenuTable (
      $weeklyMenuId TEXT PRIMARY KEY,
      $weeklyMenuTitle TEXT NOT NULL,
      $weeklyMenuDayOfWeek TEXT NOT NULL,
      $weeklyMenuUserId TEXT NOT NULL,
      $weeklyMenuUsername TEXT NOT NULL,
      $weeklyMenuUserProfileImage TEXT,
      $weeklyMenuDateCreated TEXT NOT NULL
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
  @override
  Future<int> insertCategory(CategoryModel category) async {
    final db = _database;
    return await db!.insert(categoryTable, category.toJson());
  }

  @override
  Future<List<CategoryModel>> queryAllCategories() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db!.query(categoryTable);
    return List.generate(maps.length, (i) {
      return CategoryModel.fromJson(maps[i]);
    });
  }

  @override
  Future<int> updateCategory(CategoryModel category) async {
    final db = _database;
    return await db!.update(
      categoryTable,
      category.toJson(),
      where: '$categoryId = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> deleteCategory(int id) async {
    final db = _database;
    return await db!.delete(
      categoryTable,
      where: '$categoryId = ?',
      whereArgs: [id],
    );
  }

  //For Recipes

  @override
  Future<int> insertRecipe(Recipe recipe) async {
    final db = _database;
    return await db!.insert(recipeTable, recipe.toJson());
  }

  @override
  Future<List<Recipe>> queryAllRecipes() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db!.query(recipeTable);
    return List.generate(maps.length, (i) {
      return Recipe.fromJson(maps[i]);
    });
  }
@override
  Future<List<Recipe>> queryTopThreeRecipes() async {
    final db = _database;
    final List<Map<String, dynamic>> maps =
        await db!.query(recipeTable, orderBy: '$recipeLikedBy DESC', limit: 3);
    return List.generate(maps.length, (i) {
      return Recipe.fromJson(maps[i]);
    });
  }

  @override
  Future<int> updateRecipe(Recipe recipe) async {
    final db = _database;
    return await db!.update(
      recipeTable,
      recipe.toJson(),
      where: '$recipeId = ?',
      whereArgs: [recipe.id],
    );
  }

  @override
  Future<int> deleteRecipe(int id) async {
    final db = _database;
    return await db!.delete(
      recipeTable,
      where: '$recipeId = ?',
      whereArgs: [id],
    );
  }

  //For Users

  @override
  Future<int> insertUser(User user) async {
    final db = _database;
    return await db!.insert(userTable, user.toJson());
  }

  @override
  Future<List<User>> queryAllUsers() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db!.query(userTable);
    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  @override
  Future<int> updateUser(User user) async {
    final db = _database;
    return await db!.update(
      userTable,
      user.toJson(),
      where: '$recipeId = ?',
      whereArgs: [user.id],
    );
  }

  @override
  Future<int> deleteUser(int id) async {
    final db = _database;
    return await db!.delete(
      userTable,
      where: '$userId = ?',
      whereArgs: [id],
    );
  }

  //For Comments
  @override
  Future<int> insertComment(Comment comment) async {
    final db = _database;
    return await db!.insert(commentTable, comment.toJson());
  }

  @override
  Future<List<Comment>> queryAllComments() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db!.query(commentTable);
    return List.generate(maps.length, (i) {
      return Comment.fromJson(maps[i]);
    });
  }

  @override
  Future<int> updateComment(Comment comment) async {
    final db = _database;
    return await db!.update(
      commentTable,
      comment.toJson(),
      where: '$commentId = ?',
      whereArgs: [comment.id],
    );
  }

  @override
  Future<int> deleteComment(int id) async {
    final db = _database;
    return await db!.delete(
      commentTable,
      where: '$commentId = ?',
      whereArgs: [id],
    );
  }

  @override
//for weekly menus
  Future<int> insertWeeklyMenu(WeeklyMenu weeklyMenu) async {
    final db = _database;
    return await db!.insert(weeklyMenuTable, weeklyMenu.toJson());
  }

  @override
  Future<List<WeeklyMenu>> queryAllWeeklyMenu() async {
    final db = _database;
    final List<Map<String, dynamic>> maps = await db!.query(weeklyMenuTable);
    return List.generate(maps.length, (i) {
      return WeeklyMenu.fromJson(maps[i]);
    });
  }

  @override
  Future<int> updateWeeklyMenu(WeeklyMenu weeklyMenu) async {
    final db = _database;
    return await db!.delete(
      weeklyMenuTable,
      where: '$userId = ?',
      whereArgs: [weeklyMenu.id],
    );
  }

  @override
  Future<int> deleteWeeklyMenu(int id) async {
    final db = _database;
    return await db!.delete(
      weeklyMenuTable,
      where: '$userId = ?',
      whereArgs: [id],
    );
  }
}
