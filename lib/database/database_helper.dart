import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:foodryp/database/database_interface';
import 'package:foodryp/database/database_sembast.dart';

import 'database_sqflite.dart'
    if (kIsWeb) 'database_sembast.dart';

// Factory method to get the appropriate database instance
DatabaseInterface getDatabase() {
  // Check if the code is running on the web platform
  if (kIsWeb) {
    return DatabaseSembast();  // Make sure this class is defined in `database_sembast.dart`
  } else {
    return DatabaseSqflite();  // Make sure this class is defined in `database_sqflite.dart`
  }
}
