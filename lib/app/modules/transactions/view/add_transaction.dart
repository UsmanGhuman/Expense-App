import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/icons_category/view/select_category.dart';
import 'package:expense_app/app/modules/transactions/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/helper/icons_helper.dart' as IconsHelper;
import '../models/transaction_model.dart';

class AddTransaction extends StatefulWidget {
  final TransactionModel? editTransaction;
  const AddTransaction({super.key, this.editTransaction});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  //  FIX 1: Get.put ki jagah Get.find use karein taake HomeScreen wala same instance mile aur data sync rahe
  final TransactionController controller = Get.find<TransactionController>();

  final Map<int, IconData> menuIcons = {
    0: Icons.home,
    1: Icons.card_giftcard_outlined,
    2: Icons.card_membership,
  };
  @override
  void initState() {
    super.initState();

    //  EDIT MODE CHECK: Agar editTransaction null nahi hai, to controller mein values fill karein
    if (widget.editTransaction != null) {
      controller.amount.value = widget.editTransaction!.amount.toStringAsFixed(
        0,
      );
      controller.selectCategory.value = widget.editTransaction!.category;
      controller.selectedCard.value = widget.editTransaction!.cardName;
      controller.index.value = widget.editTransaction!.isIncome
          ? 0
          : 1; // 0 = Income, 1 = Expense
    } else {
      // Fresh Mode: Values ko default par reset karein
      controller.amount.value = '0';
      controller.selectCategory.value = 'Food';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.editTransaction != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 20),

          Align(
            alignment: Alignment.center,
            child: Obx(() {
              if (controller.myCardsList.isEmpty) {
                return Text("Please add a bank card first");
              }
              return DropdownMenu(
                width: Get.width / 1.7,
                initialSelection: controller.selectedCard.value,
                leadingIcon: Icon(Icons.credit_card),
                dropdownMenuEntries: controller.myCardsList.map((card) {
                  return DropdownMenuEntry<String>(
                    value: card.cardHolderName,
                    label: card.cardHolderName,
                  );
                }).toList(),
                onSelected: (String? value) {
                  if (value != null) {
                    controller.selectedCard.value = value;
                  }
                },
              );
            }),
          ),
          SizedBox(height: 20),

          //  INCOME/EXPENSE SWITCH TABS (FIXED LOGIC)
          Align(
            alignment: Alignment.center,
            child: Container(
              width: Get.width * .7,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.offWhiteColor2,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //  FIX 2: Controller ke mutabik 0 ka matlab Income tha, to Expense ko 1 hona chahiye!
                          backgroundColor: controller.index.value == 1
                              ? AppColors.onboardGreenColor
                              : AppColors.offWhiteColor2,
                          foregroundColor: controller.index.value == 1
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          elevation: controller.index.value == 1 ? 2 : 0,
                          shadowColor: controller.index.value == 1
                              ? Colors.black26
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          controller.changeTransactionType(1); // 1 = Expense
                        },
                        child: Text('Expense'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          //  FIX 3: Controller ke mutabik 0 = Income hai!
                          elevation: controller.index.value == 0 ? 2 : 0,
                          shadowColor: controller.index.value == 0
                              ? Colors.black26
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          backgroundColor: controller.index.value == 0
                              ? AppColors.onboardGreenColor
                              : AppColors.offWhiteColor2,
                          foregroundColor: controller.index.value == 0
                              ? AppColors.whiteColor
                              : AppColors.blackColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        onPressed: () {
                          controller.changeTransactionType(0); // 0 = Income
                        },
                        child: Text('Income'),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 15),

          //  AMOUNT TEXT DISPLAY
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              return Text(
                '\$${controller.amount.value}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 54,
                  color: AppColors.onboardGreenColor,
                ),
              );
            }),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Get.width * .7,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(5),
                backgroundColor: AppColors.greyColor,
                value: .3,
                minHeight: 5,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
              ),
            ),
          ),
          SizedBox(height: 15),

          //  QUICK CATEGORY TILES ROW
          // 🎯 QUICK CATEGORY TILES ROW KO AISE UPDATE KAREIN:
          Obx(() {
            // Check karein ke current selected category in teen default mein se hai ya nahi
            final List<String> defaultCategories = [
              'Food',
              'Transport',
              'Shopping',
            ];
            final bool isCustomCategory = !defaultCategories.contains(
              controller.selectCategory.value,
            );

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                categoryMethodTile(
                  title: 'Food',
                  assetPath: 'assets/icons/food.png',
                  onTap: () => controller.changeCategory('Food'),
                ),
                categoryMethodTile(
                  title: 'Transport',
                  assetPath: 'assets/icons/transport1.png',
                  onTap: () => controller.changeCategory('Transport'),
                ),
                categoryMethodTile(
                  title: 'Shopping',
                  assetPath: 'assets/icons/shopping.png',
                  onTap: () => controller.changeCategory('Shopping'),
                ),

                // 4th DYNAMIC TILE: Agar custom category select hui to uska naam aur icon dikhaye, nahi to "More" dikhaye
                categoryMethodTile(
                  title: isCustomCategory
                      ? controller.selectCategory.value
                      : 'More',
                  // Agar custom category hai to dynamic icon lagayein, nahi to default more.png
                  isCustom: isCustomCategory,
                  assetPath: 'assets/icons/more.png',
                  onTap: () async {
                    final selectedResult = await Get.to(() => SelectCategory());

                    if (selectedResult != null && selectedResult is String) {
                      controller.changeCategory(selectedResult);
                    }
                  },
                ),
              ],
            );
          }),
          SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 15,
              crossAxisSpacing: 20,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final List<String> keys = [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '.',
                '0',
                '<',
              ];
              String currentKey = keys[index];
              return InkWell(
                onTap: () {
                  controller.onKeypadPressed(currentKey);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  child: currentKey == '<'
                      ? Icon(Icons.backspace_outlined)
                      : Text(
                          currentKey,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                          ),
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 30),
          // Step 3: Fixed ElevatedButton Logic
          //  FIX: Card verification validation check lagaya
          ElevatedButton(
            onPressed: () {
              // 1. Check karein ke list empty to nahi ya controller mein selection empty to nahi
              if (controller.myCardsList.isEmpty ||
                  controller.selectedCard.value.isEmpty) {
                Get.snackbar(
                  'Required',
                  'Please add and select a bank card first before making a transaction.',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return; // Code ko yahin rok do, aage execute nahi hoga
              }

              // 2. Agar card select hai, to normal save chalne do
              if (isEditing) {
                controller.updateTransaction(
                  widget.editTransaction!,
                  newAmount: double.tryParse(controller.amount.value) ?? 0.0,
                  newCategory: controller.selectCategory.value,
                );
              } else {
                controller.confirmTransactions();
              }
            },
            child: Text(
              isEditing ? 'Update Transaction' : 'Confirm Transaction',
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget categoryMethodTile({
    required String title,
    required String assetPath,
    required VoidCallback onTap,
    bool isCustom = false, // 🚀 Param received correctly
  }) {
    return Column(
      children: [
        Obx(() {
          // 🎯 FIX 1: Agar custom category hai, to controller ki value aur actual selectCategory ko direct match hona chahiye
          bool isSelected = controller.selectCategory.value == title;

          return IconButton(
            style: IconButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
              backgroundColor: isSelected
                  ? AppColors.onboardGreenColor
                  : AppColors.whiteColor,
            ),
            onPressed: onTap,
            // 🎯 FIX 2: Dynamic Icon rendering handle karein
            icon: isCustom
                ? Icon(
                    // More screen se selected item ka material icon dynamic fetch karein
                    IconsHelper.getCategoryIcon(
                      controller.selectCategory.value,
                    ),
                    size: 20,
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.slayColor1,
                  )
                : ImageIcon(
                    AssetImage(assetPath),
                    size: 20,
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.slayColor1,
                  ),
          );
        }),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
