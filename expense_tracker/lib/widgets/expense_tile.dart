import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ExpenseTile extends StatelessWidget {
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final IconData icon;
  final String type; // 'Income' or 'Expense'

  const ExpenseTile({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
    required this.icon, //category icon
  });
  @override
  Widget build(BuildContext context) {
    final sign = type == 'Income' ? '+' : '-';
    final amountColor =
        type == 'Income'
            ? Colors.green
            : Colors.red;
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          '$sign\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          DateFormat('dd MMM yyyy').format(date)
        ),
      ),
    );
  }
}