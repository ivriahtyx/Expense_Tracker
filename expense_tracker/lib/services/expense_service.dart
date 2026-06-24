import '../models/expense.dart';
import 'database_service.dart';

class ExpenseService {
  ExpenseService._();

  static final ExpenseService instance = ExpenseService._();

  Future<List<Expense>> getExpenses() async {
    final db = await DatabaseService.instance.database;

    final maps = await db.query('expenses');

    return maps
        .map((map) => Expense.fromMap(map))
        .toList();
  }
  

  Future<void> addExpense(Expense expense) async {
    final db = await DatabaseService.instance.database;

    await db.insert(
      'expenses',
      expense.toMap(),
    );
  }

  Future<void> deleteExpense(int id) async {
    final db = await DatabaseService.instance.database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    ); 
  }
}