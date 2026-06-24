import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class ExpenseTile extends StatelessWidget {
  final String title;
  final String category;
  final DateTime date;
  final double amount;
  final IconData icon;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon, //category icon
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          'Amount: \$${amount.toStringAsFixed(2)}',
        ),
        subtitle: Text(
          DateFormat('dd MMM yyyy').format(date)
        ),
      ),
    );
  }
}