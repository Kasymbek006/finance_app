abstract class TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final dynamic transaction;

  AddTransaction(this.transaction);
}

// 🧹 очистка всех данных
class ClearTransactions extends TransactionEvent {}