import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  String _selectedType = 'Expense'; // Default type
  String _selectedCategory = 'Food'; // Default category
  DateTime _selectedDate = DateTime.now();


  final List<Map<String, dynamic>> _expenseCategories = [
    {'label': 'Food', 'icon': Icons.restaurant},
    {'label': 'Transport', 'icon': Icons.directions_car},
    {'label': 'Shopping', 'icon': Icons.shopping_cart},
    {'label': 'Entertainment', 'icon': Icons.movie},
    {'label': 'Housing', 'icon': Icons.home},
    {'label': 'Health', 'icon': Icons.local_hospital},
    {'label': 'Travel', 'icon': Icons.flight},
    {'label': 'Other', 'icon': Icons.receipt},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {'label': 'Salary', 'icon': Icons.work},
    {'label': 'Petty Cash', 'icon': Icons.payments},
    {'label': 'Investment', 'icon': Icons.trending_up},
    {'label': 'Other', 'icon': Icons.attach_money},
  ];

  @override
  Widget build(BuildContext context) {
    final categories = _selectedType == 'Expense'
    ? _expenseCategories
    : _incomeCategories;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Expense"),
      ),
      body: SingleChildScrollView(
        child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, //for full page form
            children: [

                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment<String>(
                      value: 'Expense',
                      label: Text('Expense'),
                      icon: Icon(Icons.remove_circle_outline),
                    ),
                    ButtonSegment<String>(
                      value: 'Income',
                      label: Text('Income'),
                      icon: Icon(Icons.add_circle_outline),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (selection) {
                    setState(() {
                      _selectedType = selection.first;

                      if (_selectedType == 'Expense') {
                        _selectedCategory = 'Food';
                      } else {
                        _selectedCategory = 'Salary';
                      }
                    });
                  },
                ),

                const SizedBox(height: 20),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  }
                ),
                
                const SizedBox(height: 20),
                
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['label'] as String,
                      child: Row(
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(category['label'] as String),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                
                const SizedBox(height: 20),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  keyboardType: TextInputType.text,
                  controller: _descriptionController,
                ),
                
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Date:"), 
                    Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                    ),
                    TextButton(
                      onPressed: _selectDate,
                      child: const Text("Choose Date"),
                    ),
                  ],
                ),
                
                SizedBox(width: double.infinity, child: ElevatedButton(
                  onPressed: _saveExpense,
                  child: const Text('Add Expense'),
                ),
                )
          ],
            ),
          ),
        ),//
      )
      );
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {  
    // Handle form submission
    if (_formKey.currentState!.validate()) {

      final amount = double.parse(_amountController.text);
      
      // Process the data
      final expense = Expense(
        amount: amount,
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        type: _selectedType,
        date: _selectedDate,
      ); 
      await ExpenseService.instance.addExpense(expense);
      Navigator.pop(context); // Go back to the previous screen
    }
  }

}

