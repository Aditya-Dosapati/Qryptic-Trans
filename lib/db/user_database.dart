import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String name;
  final double balance;
  final String gender;

  User({
    this.id,
    required this.name,
    required this.balance,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'balance': balance, 'gender': gender};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      balance: map['balance'],
      gender: map['gender'],
    );
  }
}

class UserDatabase {
  // Seed 5 users if table is empty
  Future<void> seedUsers() async {
    final db = await instance.database;
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;
    if (count == 0) {
      final users = [
        User(name: 'Alice', balance: 1000, gender: 'F'),
        User(name: 'Bob', balance: 1500, gender: 'M'),
        User(name: 'Charlie', balance: 2000, gender: 'M'),
        User(name: 'David', balance: 2500, gender: 'M'),
        User(name: 'Eve', balance: 3000, gender: 'F'),
      ];
      for (final user in users) {
        await create(user);
      }
    }
  }

  // Get user by name (or add phone field and use phone)
  Future<User?> getUserByName(String name) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'balance', 'gender'],
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        balance REAL NOT NULL,
        gender TEXT NOT NULL
      )
    ''');
  }

  Future<User> create(User user) async {
    final db = await instance.database;
    final id = await db.insert('users', user.toMap());
    return user.copyWith(id: id);
  }

  Future<User?> readUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'balance', 'gender'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<int> update(User user) async {
    final db = await instance.database;
    return db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension UserCopy on User {
  User copyWith({int? id, String? name, double? balance, String? gender}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      balance: balance ?? this.balance,
      gender: gender ?? this.gender,
    );
  }
}
