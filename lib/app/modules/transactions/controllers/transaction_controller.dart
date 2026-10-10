import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/transactions/models/bank_card_model.dart';
import 'package:expense_app/app/modules/transactions/models/transaction_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/services/helper/icons_helper.dart' as IconsHelper;
import '../../../core/services/storage_service/hive_boxes.dart';

class TransactionController extends GetxController {
  RxInt index = 0.obs; // 0 = Income, 1 = Expense
  RxString selectedCard = ''.obs;
  RxString selectCategory = 'Food'.obs;

  RxInt selectedValue = 0.obs;
  RxBool isSelectedValue = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString amount = '0'.obs;

  final Box<TransactionModel> transactionBox = HiveBoxes.getTransactions();
  final RxList<TransactionModel> recentTransactions = <TransactionModel>[].obs;
  final Box<BankCardModel> cardBox = HiveBoxes.getCards();
  final RxList<BankCardModel> myCardsList = <BankCardModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCards();
    loadTransactions();
  }

  void loadCards() {
    List<BankCardModel> cards = cardBox.values.toList();
    myCardsList.assignAll(cards);

    if (myCardsList.isNotEmpty && selectedCard.value.isEmpty) {
      selectedCard.value = myCardsList.first.cardHolderName;
    }
  }

  void loadTransactions() {
    List<TransactionModel> txList = transactionBox.values.toList();
    if (kDebugMode) {
      print("Total Saved Transactions: ${txList.length}");
    }
    for(var tx in txList) {
      if (kDebugMode) {
        print("Tx: ${tx.category}, Card: ${tx.cardName}, IsIncome: ${tx.isIncome}");
      }
    }
    txList.sort((a, b) => b.id.compareTo(a.id));
    recentTransactions.assignAll(txList);
  }

  void addNewCardToList(BankCardModel newCard) async {
    await cardBox.add(newCard);
    loadCards();
    selectedCard.value = newCard.cardHolderName;
  }

  List<TransactionModel> get filteredTransactions {
    List<TransactionModel> cardTxs = recentTransactions.where((tx) => tx.cardName == selectedCard.value).toList();

    if (selectedIndex.value == 1) {
      return cardTxs.where((tx) => tx.isIncome == true).toList();
    } else if (selectedIndex.value == 2) {
      return cardTxs.where((tx) => tx.isIncome == false).toList();
    }
    return cardTxs;
  }

  // 🚀 CONFIRM TRANSACTION
  void confirmTransactions() async {
    if (amount.value == '0' || amount.value.isEmpty) {
      Get.snackbar('Error', 'Please Enter an amount', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final DateTime now = DateTime.now();
    String period = now.hour >= 12 ? 'PM' : 'AM';
    int hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    String minute = now.minute.toString().padLeft(2, '0');
    String autoTimeDisplay = 'Today $hour:$minute $period';

    // 🎯 FIX: Agar index == 1 hai (Expense tab) to isIncome false hoga!
    bool checkIncome = (index.value == 0);

    TransactionModel newTx = TransactionModel(
      id: now.millisecondsSinceEpoch.toString(),
      title: selectCategory.value,
      category: selectCategory.value,
      time: autoTimeDisplay,
      amount: double.parse(amount.value),
      isIncome: checkIncome,
      cardName: selectedCard.value,
      iconCodePoint: IconsHelper.getCategoryIcon(selectCategory.value).codePoint,
      iconColorValue: AppColors.whiteColor.toARGB32(),
      iconBgColorValue: AppColors.onboardGreenColor.toARGB32(),
    );

    await transactionBox.add(newTx);
    loadTransactions();

    amount.value = '0';
    Get.back();
    Get.snackbar('Success', 'Transaction recorded Successfully', snackPosition: SnackPosition.BOTTOM);
  }

  IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
      case 'Food & Dining': return Icons.restaurant;
      case 'Transport': return Icons.directions_car;
      case 'Shopping': return Icons.shopping_bag;
      case 'Housing': return Icons.home;
      case 'Health & Wellness': return Icons.favorite;
      case 'Travel': return Icons.flight;
      default: return Icons.category;
    }
  }

  void onKeypadPressed(String key) {
    if (key == '<') {
      if (amount.value.length <= 1) {
        amount.value = '0';
      } else {
        amount.value = amount.value.substring(0, amount.value.length - 1);
      }
    } else if (key == '.') {
      if (!amount.value.contains('.')) {
        amount.value += key;
      }
    } else {
      if (amount.value == '0') {
        amount.value = key;
      } else {
        amount.value += key;
      }
    }
  }

  // ==========================================
  // DASHBOARD DYNAMIC CALCULATIONS (GETTERS)
  // ==========================================
  double get totalIncome {
    return recentTransactions
        .where((tx) => tx.isIncome == true && tx.cardName == selectedCard.value)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalExpense {
    return recentTransactions
        .where((tx) => tx.isIncome == false && tx.cardName == selectedCard.value)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalBalance => totalIncome - totalExpense;

  double get totalSavings {
    double savings = totalIncome - totalExpense;
    return savings < 0 ? 0.0 : savings;
  }

  // 🟢 Category BreakDown Perfect Filter
  Map<String, double> get categoryPercentage {
    // 🎯 Sirf current selected card ki Expenses transactions nikalen
    var expenseTxs = recentTransactions
        .where((tx) => tx.isIncome == false && tx.cardName == selectedCard.value)
        .toList();

    if (expenseTxs.isEmpty) return {};

    Map<String, double> categoryAmounts = {};
    for (var tx in expenseTxs) {
      categoryAmounts[tx.category] = (categoryAmounts[tx.category] ?? 0) + tx.amount;
    }

    double expenseTotal = totalExpense;
    if (expenseTotal == 0) return {};

    return categoryAmounts.map((key, value) {
      double percentage = (value / expenseTotal) * 100;
      return MapEntry(key, percentage);
    });
  }
  // ==========================================

  void changeCategory(String categoryName) {
    selectCategory.value = categoryName;
  }

  void changeTransactionType(int newIndex) {
    index.value = newIndex;
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
// 🚀 Pure Hive Delete: Na loop, na ID matching!
  void deleteTransaction(TransactionModel transaction) async {
    // HiveObject ki wajah se transaction ke paas apni key khud hoti hai
    await transaction.delete();

    loadTransactions(); // UI refresh karne ke liye
    Get.snackbar(
        'Success',
        'Transaction deleted successfully',
        snackPosition: SnackPosition.BOTTOM
    );
  }
// 🚀 FIXED: Aapke specific TransactionModel fields ke mutabik pure Hive Update
  void updateTransaction(TransactionModel oldTx, {required double newAmount, required String newCategory}) async {

    // 1. Naya object banayein purane object ki ID aur baqi details ko maintain rakhte hue
    final updatedTx = TransactionModel(
      id: oldTx.id, // ID purani hi rahegi
      title: newCategory, // Naya category name hi title banega
      category: newCategory, // Nayi category apply ho gayi
      time: oldTx.time, // Time purana hi maintain rakhein
      amount: newAmount, // Naya amount apply ho gaya
      isIncome: oldTx.isIncome, // Type (Income/Expense) purani hi rahegi
      cardName: oldTx.cardName, // Card purana hi rahegi
      iconCodePoint: IconsHelper.getCategoryIcon(newCategory).codePoint, // Naya dynamic icon code
      iconColorValue: oldTx.iconColorValue, // Colors purane hi maintain rahenge
      iconBgColorValue: oldTx.iconBgColorValue,
    );

    // 2. Pure Hive Magic: Agar key maujood hai, to direct usi exact key par override kar dein
    if (oldTx.key != null) {
      await transactionBox.put(oldTx.key, updatedTx);

      loadTransactions(); // UI list auto-refresh karne ke liye

      Get.back(); // Screen close karne ke liye
      Get.snackbar(
          'Success',
          'Transaction updated successfully',
          snackPosition: SnackPosition.BOTTOM
      );
    } else {
      Get.snackbar(
          'Error',
          'Something went wrong while updating',
          snackPosition: SnackPosition.BOTTOM
      );
    }
  }
}