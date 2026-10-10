import 'package:expense_app/app/modules/analytics/controllers/budget_controller.dart';
import 'package:expense_app/app/modules/icons_category/view/select_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';

import '../../goals/view/category_card.dart';
import '../models/budget_model.dart';

class NewBudget extends StatefulWidget {
  final BudgetModel? editBudget;
  const NewBudget({super.key, this.editBudget});

  @override
  State<NewBudget> createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final amountController = TextEditingController();
  final goalController = TextEditingController();
  final dateController = TextEditingController();
  final initialAmountController = TextEditingController();
  final BudgetController budgetController = Get.put(BudgetController());

  @override
  void initState() {
    super.initState();
    // EDIT MODE CHECK: Slide/Click karke data populate karein
    if (widget.editBudget != null) {
      amountController.text = widget.editBudget!.targetAmount.toStringAsFixed(
        0,
      );
      goalController.text = widget.editBudget!.name;
      dateController.text = widget.editBudget!.targetDate;
      initialAmountController.text = widget.editBudget!.savedAmount
          .toStringAsFixed(0);
      budgetController.selectedCategory.value = widget.editBudget!.category;
      budgetController.hasText.value = true;
    } else {
      budgetController.selectedCategory.value = 'Travel';
      budgetController.hasText.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editBudget != null;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing ? 'Edit Budget' : 'New Budget',
          style: TextStyle(fontSize: 16, color: AppColors.blackColor),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: Offset(0, 4),
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
                        fontWeight: budgetController.hasText.value
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppColors.blackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '10,000',
                        filled: false,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.greyColor,
                          fontSize: 48,
                        ),
                        prefixText: budgetController.hasText.value ? '\$' : '',
                        prefixStyle: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        budgetController.hasText.value = value.isNotEmpty;
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: Offset(0, 4),
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
                  decoration: InputDecoration(hintText: 'European'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: Offset(0, 4),
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: Offset(0, 4),
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
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: [
                    Obx(
                      () => CategoryCard(
                        title: 'Travel',
                        icon: Icons.flight,
                        isSelected:
                            budgetController.selectedCategory.value == 'Travel',
                        onTap: () {
                          budgetController.selectedCategory.value = 'Travel';
                        },
                      ),
                    ),
                    Obx(
                      () => CategoryCard(
                        title: 'Home',
                        icon: Icons.home,
                        isSelected:
                            budgetController.selectedCategory.value == 'Home',
                        onTap: () {
                          budgetController.selectedCategory.value = 'Home';
                        },
                      ),
                    ),
                    Obx(
                      () => CategoryCard(
                        title: 'Vehicle',
                        icon: Icons.directions_car,
                        isSelected:
                            budgetController.selectedCategory.value ==
                            'Transport',
                        onTap: () {
                          budgetController.selectedCategory.value = 'Transport';
                        },
                      ),
                    ),
                    //  UPDATE: GridView ke andar 'More' card ko is fully dynamic code se badlein:
                    Obx(() {
                      final currentCat =
                          budgetController.selectedCategory.value;
                      final isStandardCategory =
                          currentCat == 'Travel' ||
                          currentCat == 'Home' ||
                          currentCat == 'Transport';
                      final isMoreSelected =
                          !isStandardCategory && currentCat.isNotEmpty;

                      // 🚀 Local helper jo dynamic icon return karega jab 'More' select ho
                      IconData getCustomCategoryIcon(String catName) {
                        switch (catName) {
                          case 'Food & Dining':
                          case 'Food':
                            return Icons.restaurant;
                          case 'Shopping':
                            return Icons.shopping_bag;
                          case 'Health & Wellness':
                          case 'Health':
                            return Icons.favorite;
                          case 'Education':
                            return Icons.school;
                          case 'Entertainment':
                            return Icons.sports_esports;
                          case 'Utilities':
                            return Icons.bolt;
                          case 'Groceries':
                            return Icons.shopping_cart;
                          case 'Gifts & Donations':
                            return Icons.volunteer_activism;
                          case 'Investments':
                            return Icons.trending_up;
                          case 'Personal Care':
                            return Icons.face;
                          case 'Insurance':
                            return Icons.verified_user;
                          default:
                            return Icons
                                .category; // Safe fallback icon agar kuch match na ho
                        }
                      }

                      return CategoryCard(
                        title: isMoreSelected ? currentCat : 'More',
                        //  FIX: Agar koi custom category selected hai to uska icon aaye, warna teen dots (more_horiz) aayein
                        icon: isMoreSelected
                            ? getCustomCategoryIcon(currentCat)
                            : Icons.more_horiz,
                        isSelected: isMoreSelected,
                        onTap: () async {
                          final selectedResult = await Get.to(
                            () => SelectCategory(),
                          );

                          if (selectedResult != null &&
                              selectedResult is String) {
                            if (selectedResult == 'Housing' ||
                                selectedResult == 'Home') {
                              budgetController.selectedCategory.value = 'Home';
                            } else if (selectedResult == 'Transport') {
                              budgetController.selectedCategory.value =
                                  'Transport';
                            } else {
                              budgetController.selectedCategory.value =
                                  selectedResult;
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.colors,
                  offset: Offset(0, 4),
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
                width: Get.width * 0.355,
                child: TextField(
                  controller: initialAmountController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: AppColors.darkGreyColor),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
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
          //  NewBudget screen ke bilkul aakhir mein ElevatedButton ko aise badlein:
          ElevatedButton(
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

              // Check karein ke widget.editBudget null hai ya nahi (Slide se aaye hain ya direct)
              if (widget.editBudget != null) {
                budgetController.updateBudget(
                  widget.editBudget!,
                  name: goalController.text,
                  target: double.parse(amountController.text),
                  date: dateController.text,
                  category: budgetController.selectedCategory.value,
                  initialContribution: initialAmountController.text.isEmpty
                      ? 0.0
                      : double.parse(initialAmountController.text),
                );
              } else {
                budgetController.addNewBudget(
                  name: goalController.text,
                  target: double.parse(amountController.text),
                  date: dateController.text,
                  category: budgetController.selectedCategory.value,
                  initialContribution: initialAmountController.text.isEmpty
                      ? 0.0
                      : double.parse(initialAmountController.text),
                );
              }
            },
            child: Text(
              widget.editBudget != null ? 'Update Budget' : 'Create Budget',
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
