import 'package:expense_app/app/core/services/storage_service/hive_boxes.dart';
import 'package:expense_app/app/modules/analytics/models/budget_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class BudgetController extends GetxController {
  RxBool hasText = false.obs;
  RxString selectedCategory = 'Travel'.obs;

  final Box<BudgetModel> budgetBox = HiveBoxes.getBudget();
  final RxList savedBudgetList = <BudgetModel>[].obs;

  RxDouble totalAmountBudget = 0.0.obs;
  RxDouble totalSavedAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadBudget();
  }

  void loadBudget() {
    savedBudgetList.assignAll(budgetBox.values.toList());
    calculateTotals();
  }

  void calculateTotals() {
    double totalBudget = 0.0;
    double totalSaved = 0.0;
    for (var budget in savedBudgetList) {
      totalBudget += budget.targetAmount;
      totalSaved += budget.savedAmount;
    }

    totalAmountBudget.value = totalBudget;
    totalSavedAmount.value = totalSaved;
  }

  Future<void> addNewBudget({
    required String name,
    required double target,
    required String date,
    required String category,
    required double initialContribution,
  }) async {
    final newBudget = BudgetModel(
      name: name,
      targetAmount: target,
      targetDate: date,
      category: category,
      savedAmount: initialContribution,
    );
    await budgetBox.add(newBudget);
    loadBudget();

    //  RESET STATE: Agli baar fresh budget banane ke liye clean state mile
    selectedCategory.value = 'Travel';
    hasText.value = false;

    Get.back();
    Get.snackbar(
      'Success',
      'Budget Created Successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
// 🚀 PURE HIVE UPDATE: Direct value override via .save()
  Future<void> updateBudget(
      BudgetModel oldBudget, {
        required String name,
        required double target,
        required String date,
        required String category,
        required double initialContribution,
      }) async {
    // fields ko direct re-assign karein kyunki model variables final nahi hain!
    oldBudget.name = name;
    oldBudget.targetAmount = target;
    oldBudget.targetDate = date;
    oldBudget.category = category;
    oldBudget.savedAmount = initialContribution;

    await oldBudget.save(); // Hive automatically updates database row!
    loadBudget();

    Get.back();
    Get.snackbar('Success', 'Budget Updated Successfully', snackPosition: SnackPosition.BOTTOM);
  }
  // Future<void> deleteBudget(int index) async {
  //   await budgetBox.deleteAt(index);
  //   loadBudget();
  // }
  // 🚀 PURE HIVE DELETE FUNCTION
  Future<void> deleteBudget(BudgetModel budget) async {
    // Hive database se directly row delete karega
    await budget.delete();

    // UI list ko refresh aur totals ko recalculate karega
    loadBudget();

    Get.snackbar(
      'Deleted',
      'Budget Deleted Successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}