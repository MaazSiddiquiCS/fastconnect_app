import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/user_model.dart';

// data/datasources/auth_local_data_source.dart

import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';
import '../../../core/database/app_database.dart'; // Your AppDatabase class

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCurrentUser();
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase appDatabase;

  AuthLocalDataSourceImpl(this.appDatabase);

  @override
  Future<void> cacheUser(UserModel user) async {
    final db = await appDatabase.database;

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final db = await appDatabase.database;
    final maps = await db.query('users', limit: 1);

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    final db = await appDatabase.database;
    await db.delete('users');
  }
}