import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/balance_card.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_screen.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //final expenses = ExpenseService.instance.getExpenses();
    List<Expense> _expenses = [];
    double _total = 0.0;

    @override
    void initState() {
      super.initState();
      _loadExpenses();
    }

    Future<void> _loadExpenses() async {
      final expenses = await ExpenseService.instance.getExpenses();

      double total = 0;
      for (final expense in expenses) {
        total += expense.amount;
      }

      setState(() {
        _expenses = expenses;
        _total = total;
      });
    }

    // Calculate the total amount spent
    // final total = _expenses.fold<double>(
    //   0,
    //   (sum, expense) => sum + expense.amount,
    // );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async { 
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );
          // Action to add a new expense
          await _loadExpenses();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Expense Tracker"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(balance: _total, transactionCount: _expenses.length),
              const SizedBox(height: 24),

              const Text(
                "Recent Expenses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              for (final expense in _expenses)
                ExpenseTile(
                  title: expense.description,
                  amount: expense.amount,
                  date: expense.date,
                  category: expense.category,
                  icon: expense.category == 'Food' ? Icons.fastfood : 
                         expense.category == 'Transport' ? Icons.directions_car : 
                         expense.category == 'Shopping' ? Icons.shopping_cart : 
                         Icons.receipt, // You can customize this based on category
                ),               
            ],
          ),
        ),
      ),
    );
  }
}