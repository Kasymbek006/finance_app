import 'package:flutter_bloc/flutter_bloc.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';
import '../models/transaction_model.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(const TransactionState(transactions: [])) {

    // ➕ добавить транзакцию
    on<AddTransaction>((event, emit) {
      final updated = List<TransactionModel>.from(state.transactions)
        ..add(event.transaction);

      emit(TransactionState(transactions: updated));
    });

    // 🧹 очистить все
    on<ClearTransactions>((event, emit) {
      emit(const TransactionState(transactions: []));
    });
  }
}