import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/goals/controllers/new_goal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../icons_category/view/select_category.dart';
import '../models/goal_model.dart';
import 'category_card.dart';

class NewGoal extends StatefulWidget {
  final GoalModel? goalModel; // 🎯 Optional model accept karein
  const NewGoal({super.key,this.goalModel});

  @override
  State<NewGoal> createState() => _NewGoalState();
}

class _NewGoalState extends State<NewGoal> {
  final amountController = TextEditingController();
  final goalController = TextEditingController();
  final dateController = TextEditingController();
  final initialAmountController = TextEditingController();
  final NewGoalController controller = Get.put(NewGoalController());

  @override
  void initState() {
    super.initState();

    // 🎯 Agar goalModel null nahi hai, to direct edit mode on karein
    if (widget.goalModel != null) {
      controller.isEditing.value = true;
      // 🚀 FIX: Hive model ki unique key ko controller ke editingIndex variable mein hi store karwa liya
      controller.editingIndex = widget.goalModel!.key;

      amountController.text = widget.goalModel!.targetAmount.toStringAsFixed(0);
      goalController.text = widget.goalModel!.name;
      dateController.text = widget.goalModel!.targetDate;
      initialAmountController.text = widget.goalModel!.savedAmount.toStringAsFixed(0);
    } else {
      // Agar naya goal ban raha hai to edit mode false rahe
      controller.isEditing.value = false;
    }
  }
  @override
  void dispose() {
    amountController.dispose();
    goalController.dispose();
    dateController.dispose();
    initialAmountController.dispose();

    // 🚀 Reset controller states
    controller.isEditing.value = false;
    controller.editingIndex = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.goalModel != null;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor:  Color(0xFFF3F4F5),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing ? 'Edit Goal' : 'New Goal',
          style: TextStyle(fontSize: 16, color: AppColors.blackColor),
        ),
      ),
      body: ListView(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        children: [
           SizedBox(height: 20),
          Container(
            padding:  EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset:  Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Target Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.greishColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Obx(
                      () => IntrinsicWidth(
                    child: TextFormField(
                      controller: amountController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: controller.hasText.value
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '10,000',
                        filled: false,
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                            color: AppColors.greyColor
                        ),
                        prefixText: controller.hasText.value ? '\$' : '',
                        prefixStyle:  TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        controller.hasText.value = value.isNotEmpty;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset:  Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Goal Name',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.greishColor,
                  ),
                ),
                 SizedBox(height: 8),
                TextField(
                  controller: goalController,
                  decoration:  InputDecoration(hintText: 'European'),
                ),
              ],
            ),
          ),
           SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: const Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Date',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.greishColor,
                  ),
                ),
                 SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    }
                  },
                  controller: dateController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.date_range_outlined,
                      color: AppColors.greishColor,
                    ),
                    hintText: 'mm/dd/yyyy',
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset:  Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.greishColor,
                  ),
                ),
                 SizedBox(height: 8),
                GridView.count(
                  shrinkWrap: true,
                  physics:  NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    Obx(() => CategoryCard(
                      title: 'Travel',
                      icon: Icons.flight,
                      isSelected: controller.selectedCategory.value == 'Travel',
                      onTap: () {
                        controller.selectedCategory.value = 'Travel';
                      },
                    )),
                    Obx(() => CategoryCard(
                      title: 'Home',
                      icon: Icons.home,
                      isSelected: controller.selectedCategory.value == 'Home',
                      onTap: () {
                        controller.selectedCategory.value = 'Home';
                      },
                    )),
                    Obx(() => CategoryCard(
                      title: 'Vehicle',
                      icon: Icons.directions_car,
                      isSelected: controller.selectedCategory.value == 'Vehicle',
                      onTap: () {
                        controller.selectedCategory.value = 'Vehicle';
                      },
                    )),
                    Obx(() {
                      final currentCat = controller.selectedCategory.value;
                      final isStandardCategory = currentCat == 'Travel' || currentCat == 'Home' || currentCat == 'Vehicle';
                      final isMoreSelected = !isStandardCategory && currentCat.isNotEmpty;

                      IconData getLocalIcon(String catName) {
                        switch (catName) {
                          case 'Food & Dining': return Icons.restaurant;
                          case 'Shopping': return Icons.shopping_bag;
                          case 'Health & Wellness': return Icons.favorite;
                          case 'Education': return Icons.school;
                          case 'Entertainment': return Icons.sports_esports;
                          case 'Utilities': return Icons.bolt;
                          case 'Groceries': return Icons.shopping_cart;
                          case 'Gifts & Donations': return Icons.volunteer_activism;
                          case 'Investments': return Icons.trending_up;
                          case 'Personal Care': return Icons.face;
                          case 'Insurance': return Icons.verified_user;
                          default: return Icons.category;
                        }
                      }

                      return CategoryCard(
                        title: isMoreSelected ? currentCat : 'More',
                        icon: isMoreSelected ? getLocalIcon(currentCat) : Icons.more_horiz,
                        isSelected: isMoreSelected,
                        onTap: () async {
                          final selectedResult = await Get.to(() => const SelectCategory());

                          if (selectedResult != null && selectedResult is String) {
                            if (selectedResult == 'Housing' || selectedResult == 'Home') {
                              controller.selectedCategory.value = 'Home';
                            }
                            else if (selectedResult == 'Transport' || selectedResult == 'Vehicle') {
                              controller.selectedCategory.value = 'Vehicle';
                            }
                            else {
                              controller.selectedCategory.value = selectedResult;
                            }
                          }
                        },
                      );
                    }),

                  ],
                ),
              ],
            ),
          ),
           SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset:  Offset(0, 4),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                'Initial Contribution',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
              ),
              subtitle: Text(
                'Optional Starting Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: AppColors.greishColor,
                ),
              ),
              trailing: SizedBox(
                width: 128,
                child: TextField(
                  controller: initialAmountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: AppColors.darkGreyColor),
                    prefixIcon: Padding(
                      padding:  EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      child: Text(
                        '\$',
                        style: TextStyle(
                          color: AppColors.greishColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 0,
              minVerticalPadding: 12,
              minTileHeight: 35,
            ),
          ),
           SizedBox(height: 24),
          Obx(() => ElevatedButton(
            onPressed: () {
              if (goalController.text.isEmpty ||
                  amountController.text.isEmpty ||
                  dateController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please fill all Mandatory Fields',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              if (controller.isEditing.value) {
                // ✏️ UPDATE GOAL EXECUTION
                // 🚀 FIX: 'index' ko hata kar 'goalKey' pass kiya jo controller demand kar raha tha
                controller.updateGoal(
                  goalKey: controller.editingIndex!,
                  name: goalController.text,
                  target: double.parse(amountController.text),
                  date: dateController.text,
                  category: controller.selectedCategory.value,
                  savedAmount: initialAmountController.text.isEmpty
                      ? 0.0
                      : double.parse(initialAmountController.text),
                );
              } else {
                // 🟢 CREATE NEW GOAL EXECUTION
                controller.addNewGoals(
                  name: goalController.text,
                  target: double.parse(amountController.text),
                  date: dateController.text,
                  category: controller.selectedCategory.value,
                  initialContribution: initialAmountController.text.isEmpty
                      ? 0.0
                      : double.parse(initialAmountController.text),
                );
              }
            },
            child: Text(controller.isEditing.value ? 'Update Goal' : 'Create Goal'),
          )),
           SizedBox(height: 40),
        ],
      ),
    );
  }
}