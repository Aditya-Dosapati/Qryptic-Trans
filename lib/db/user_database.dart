import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class User {
  final int? id;
  final String name;
  final String phone;
  final double balance;
  final String gender;

  User({
    this.id,
    required this.name,
    required this.phone,
    required this.balance,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'balance': balance,
      'gender': gender,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      balance: map['balance'],
      gender: map['gender'],
    );
  }
}

extension UserCopy on User {
  User copyWith({
    int? id,
    String? name,
    String? phone,
    double? balance,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      gender: gender ?? this.gender,
    );
  }
}

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;

  // Cache for better performance
  // Cache removed to avoid stale reads

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('users.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        balance REAL NOT NULL,
        gender TEXT NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Drop and recreate table to ensure phone and gender columns exist
      await db.execute('DROP TABLE IF EXISTS users');
      await _createDB(db, newVersion);
    }
    if (oldVersion < 3) {
      // One-time adjustment: set the first (primary) user's balance to ₹1500
      await db.execute('''
        UPDATE users
        SET balance = 1500
        WHERE id = (
          SELECT id FROM users ORDER BY id ASC LIMIT 1
        )
      ''');
    }
  }

  Future<void> seedUsers() async {
    final db = await instance.database;
    final count =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;
    if (count == 0) {
      final users = [
        User(name: 'ADI D', phone: '8332034345', balance: 100000, gender: 'M'),
        User(name: 'Bob', phone: '9000000002', balance: 1500, gender: 'M'),
        User(name: 'Charlie', phone: '9000000003', balance: 2000, gender: 'M'),
        User(name: 'David', phone: '9000000004', balance: 2500, gender: 'M'),
        User(name: 'Eve', phone: '9000000005', balance: 3000, gender: 'F'),
      ];
      for (final user in users) {
        await create(user);
      }
    }
  }

  Future<User?> getUserByName(String name) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'phone', 'balance', 'gender'],
      where: 'name = ?',
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<User> create(User user) async {
    final db = await instance.database;
    final id = await db.insert('users', user.toMap());
    // Invalidate cache so subsequent reads reflect latest data
    _invalidateCache();
    return user.copyWith(id: id);
  }

  Future<User?> readUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      columns: ['id', 'name', 'phone', 'balance', 'gender'],
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

  Future<User?> readFirstUser() async {
    final db = await instance.database;
    final result = await db.query('users', orderBy: 'id ASC', limit: 1);
    if (result.isEmpty) return null;
    return User.fromMap(result.first);
  }

  /// Returns the first user with caching, seeding defaults if the table is empty.
  Future<User> readOrSeedFirstUser() async {
    try {
      // Ensure we have users
      await seedUsers();

      final existing = await readFirstUser();
      if (existing != null) {
        return existing;
      }

      // Fallback: create a minimal default user
      final created = await create(
        User(
          name: 'Guest User',
          phone: '1234567890',
          balance: 1000,
          gender: 'M',
        ),
      );

      return created;
    } catch (e) {
      // Emergency fallback
      print('Database error: $e');
      final created = await create(
        User(
          name: 'Emergency User',
          phone: '0000000000',
          balance: 500,
          gender: 'M',
        ),
      );
      return created;
    }
  }

  Future<int> update(User user) async {
    final db = await instance.database;
    final result = await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    // Invalidate cache so subsequent reads reflect latest balance
    _invalidateCache();
    return result;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final result = await db.delete('users', where: 'id = ?', whereArgs: [id]);
    // Invalidate cache after deletion
    _invalidateCache();
    return result;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // --- Cache helpers ---
  void _invalidateCache() {}
}
