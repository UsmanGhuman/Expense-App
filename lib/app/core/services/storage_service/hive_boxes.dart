

import 'package:expense_app/app/modules/analytics/models/budget_model.dart';
import 'package:expense_app/app/modules/goals/models/goal_model.dart';
import 'package:expense_app/app/modules/transactions/models/bank_card_model.dart';
import 'package:expense_app/app/modules/transactions/models/transaction_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  static Box<GoalModel> getGoals () => Hive.box<GoalModel>('goalBox');
  static Box<BudgetModel> getBudget () => Hive.box<BudgetModel>('budgetBox');
  static Box<BankCardModel> getCards () => Hive.box<BankCardModel>('bankCard');
  static Box<TransactionModel> getTransactions() => Hive.box<TransactionModel>('transaction_box');
}