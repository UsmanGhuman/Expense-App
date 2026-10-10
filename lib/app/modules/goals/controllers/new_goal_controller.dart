import 'package:expense_app/app/core/services/storage_service/hive_boxes.dart';
import 'package:expense_app/app/modules/goals/models/goal_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NewGoalController extends GetxController {
  RxBool hasText = false.obs;
  RxString selectedCategory = 'Travel'.obs;

  final Box<GoalModel> goalBox = HiveBoxes.getGoals();
  final RxList savedGoalsList = <GoalModel>[].obs;

  //  EDIT MODE TRACKING VARIABLES
  RxBool isEditing = false.obs;
  int? editingIndex; // Hive mein update karne ke liye index track karenge

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  void loadGoals() {
    savedGoalsList.assignAll(goalBox.values.toList());
  }

  Future<void> addNewGoals({
    required String name,
    required double target,
    required String date,
    required String category,
    required double initialContribution,
  }) async {
    final newGoal = GoalModel(
      name: name,
      targetAmount: target,
      targetDate: date,
      category: category,
      savedAmount: initialContribution,
    );
    await goalBox.add(newGoal);
    savedGoalsList.add(newGoal);

    //  RESET STATE: Agli baar jab screen khule toh fresh default state ho
    selectedCategory.value = 'Travel';
    hasText.value = false;

    Get.back();
    Get.snackbar(
      'Success',
      'Goal Created Successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  //  UPDATE EXISTING GOAL FUNCTION (In NewGoalController)
  Future<void> updateGoal({
    required dynamic goalKey, // Key accept karein index ki jagah
    required String name,
    required double target,
    required String date,
    required String category,
    required double savedAmount,
  }) async {
    final updatedGoal = GoalModel(
      name: name,
      targetAmount: target,
      targetDate: date,
      category: category,
      savedAmount: savedAmount,
    );

    //  FIX: putAt ki jagah direct key par update karein, kabhi range error nahi aayega
    await goalBox.put(goalKey, updatedGoal);

    loadGoals(); // List refresh karein
    Get.back();
    Get.snackbar('Success', 'Goal Updated Successfully', snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> deleteGoal(int index) async {
    await goalBox.deleteAt(index);
    loadGoals();
  }
}