import '../models/user_model.dart';

class LocalDB {
  static final List<UserModel> users = [
    UserModel(
      id: 1,
      name: "Aditya",
      balance: 5000,
      transactions: [
        TransactionModel(
          amount: -200,
          description: "Mobile Recharge",
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        TransactionModel(
          amount: 1500,
          description: "Salary Credit",
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TransactionModel(
          amount: -100,
          description: "Coffee",
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    ),
    UserModel(
      id: 2,
      name: "Rohit",
      balance: 3200,
      transactions: [
        TransactionModel(
          amount: -400,
          description: "Electricity Bill",
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TransactionModel(
          amount: 2500,
          description: "Freelance Payment",
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
    ),
    // Add 3 more dummy users here...
  ];
}
