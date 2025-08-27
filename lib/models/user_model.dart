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
}
