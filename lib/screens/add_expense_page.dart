import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../models/transaction_model.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final controller = TextEditingController();
  String category = 'Food';
  String? errorText;

  final Map<String, IconData> categories = {
    'Food': Icons.fastfood,
    'Taxi': Icons.local_taxi,
    'Shopping': Icons.shopping_bag,
    'Tech': Icons.devices,
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // закрытие клавы
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔥 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_down, color: Colors.white, size: 30),
                    SizedBox(width: 10),
                    Text(
                      "Add Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 💰 INPUT
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter amount",
                    prefixIcon:
                        const Icon(Icons.attach_money, color: Colors.red),
                    errorText: errorText,
                  ),
                  onChanged: (_) {
                    if (errorText != null) {
                      setState(() => errorText = null);
                    }
                  },
                ),
              ),

              const SizedBox(height: 25),

              // 🎯 CATEGORY
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categories.entries.map((entry) {
                  final selected = entry.key == category;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ChoiceChip(
                      avatar: Icon(
                        entry.value,
                        size: 18,
                        color: selected ? Colors.white : Colors.black54,
                      ),
                      label: Text(entry.key),
                      selected: selected,
                      showCheckmark: false, // ❌ убрали галочку
                      selectedColor: Colors.red,
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (_) => setState(() => category = entry.key),
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              // 🔥 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    final text = controller.text.trim();
                    final amount = double.tryParse(text);

                    // ❌ ошибка
                    if (amount == null || amount <= 0) {
                      setState(() {
                        errorText = "Enter valid amount";
                      });
                      return;
                    }

                    context.read<TransactionBloc>().add(
                          AddTransaction(
                            TransactionModel(
                              id: DateTime.now().millisecondsSinceEpoch,
                              amount: amount,
                              category: category,
                              type: TransactionType.expense,
                            ),
                          ),
                        );

                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: const Text(
                    "Add Expense",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}