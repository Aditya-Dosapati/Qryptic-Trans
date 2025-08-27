import '../db/user_database.dart';

class TransactionModel {
  final double amount;
  final String description;
  final DateTime date;

  TransactionModel({
    required this.amount,
    required this.description,
    required this.date,
  });
}

class UserModel {
  final int id;
  final String name;
  final double balance;
  final List<TransactionModel> transactions;

  UserModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.transactions,
  });

  // Convert from User (db) to UserModel (UI)
  factory UserModel.fromUser(
    User user, {
    List<TransactionModel>? transactions,
  }) {
    return UserModel(
      id: user.id ?? 0,
      name: user.name,
      balance: user.balance,
      transactions: transactions ?? [],
    );
  }

  // Convert from UserModel (UI) to User (db)
  User toUser({String? phone, String? gender}) {
    return User(
      id: id,
      name: name,
      phone: phone ?? '',
      balance: balance,
      gender: gender ?? '',
    );
  }
}
