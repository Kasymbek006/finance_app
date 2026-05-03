import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_state.dart';
import '../models/transaction_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          double income = 0;
          double expense = 0;

          for (var t in state.transactions) {
            if (t.type == TransactionType.income) {
              income += t.amount;
            } else {
              expense += t.amount;
            }
          }

          double balance = income - expense;

          // 📊 категории расходов
          Map<String, double> categoryTotals = {};
          for (var t in state.transactions) {
            if (t.type == TransactionType.expense) {
              categoryTotals[t.category] =
                  (categoryTotals[t.category] ?? 0) + t.amount;
            }
          }

          final totalExpense =
              categoryTotals.values.fold(0.0, (a, b) => a + b);

          final sections = categoryTotals.entries.map((e) {
            final percent = totalExpense == 0
                ? 0
                : (e.value / totalExpense) * 100;

            return PieChartSectionData(
              value: e.value,
              color: _getColor(e.key),
              title: "${percent.toStringAsFixed(0)}%",
              radius: 55,
              titleStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [

                // 💳 BALANCE CARD
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Balance",
                          style: TextStyle(color: Colors.white70)),

                      const SizedBox(height: 8),

                      Text(
                        "\$${balance.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 34,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _moneyBlock("Income", income, Colors.greenAccent),
                          _moneyBlock("Expense", expense, Colors.redAccent),
                        ],
                      )
                    ],
                  ),
                ),

                // 📊 CHART CARD
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Expenses Overview",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 200,
                        child: categoryTotals.isEmpty
                            ? const Center(child: Text("No data"))
                            : PieChart(
                                PieChartData(
                                  sections: sections,
                                  centerSpaceRadius: 45,
                                  sectionsSpace: 2,
                                ),
                              ),
                      ),

                      const SizedBox(height: 15),

                      // 🏷 ЛЕГЕНДА
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: categoryTotals.keys.map((c) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _getColor(c),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(c,
                                  style: const TextStyle(fontSize: 13)),
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📋 TRANSACTIONS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, i) {
                    final t = state.transactions[i];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                          )
                        ],
                      ),
                      child: Row(
                        children: [

                          // ICON
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: t.type == TransactionType.income
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              t.type == TransactionType.income
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: t.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // TEXT
                          Expanded(
                            child: Text(
                              t.category,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),

                          // AMOUNT
                          Text(
                            "\$${t.amount}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: t.type == TransactionType.income
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// 💰 блок
Widget _moneyBlock(String title, double value, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 4),
      Text(
        "\$${value.toStringAsFixed(0)}",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}

// 🎨 цвета категорий
Color _getColor(String category) {
  switch (category) {
    case 'Food':
      return Colors.orange;
    case 'Taxi':
      return Colors.blue;
    case 'Shopping':
      return Colors.purple;
    case 'Tech':
      return Colors.green;
    default:
      return Colors.grey;
  }
}IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'Food':
      return Icons.fastfood;
    case 'Taxi':
      return Icons.local_taxi;
    case 'Shopping':
      return Icons.shopping_bag;
    case 'Tech':
      return Icons.devices;
    case 'Salary':
      return Icons.account_balance;
    case 'Business':
      return Icons.business_center;
    case 'Gift':
      return Icons.card_giftcard;
    default:
      return Icons.category;
  }
}