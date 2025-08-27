import 'db/user_database.dart';

// Example usage for dynamic user operations
Future<List<User>> getAllUsers() async {
  return await UserDatabase.instance.readAllUsers();
}

Future<User?> getUserById(int id) async {
  return await UserDatabase.instance.readUser(id);
}

Future<User> addUser(User user) async {
  return await UserDatabase.instance.create(user);
}

Future<int> updateUser(User user) async {
  return await UserDatabase.instance.update(user);
}

Future<int> deleteUser(int id) async {
  return await UserDatabase.instance.delete(id);
}
