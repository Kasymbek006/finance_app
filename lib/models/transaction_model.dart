enum TransactionType { income, expense }

class TransactionModel {
  final int id;
  final double amount;
  final String category;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
  });
}