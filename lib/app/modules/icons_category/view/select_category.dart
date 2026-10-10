import 'package:expense_app/app/modules/transactions/controllers/transaction_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  //  Note: Agar aapko TransactionController ka directly yahan koi kaam nahi hai toh is line ko hata bhi sakte hain
  final TransactionController controller = Get.put(TransactionController());

  final List<Map<String, dynamic>> categories = [
    {'name': 'Food & Dining', 'icon': Icons.restaurant, 'color': AppColors.offWhiteColor2}, // Standardized name
    {'name': 'Transport', 'icon': Icons.directions_car, 'color': AppColors.offWhiteColor2},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': AppColors.offWhiteColor2},
    {'name': 'Housing', 'icon': Icons.home, 'color': AppColors.offWhiteColor2},
    {'name': 'Health & Wellness', 'icon': Icons.favorite, 'color': AppColors.offWhiteColor2},
    {'name': 'Travel', 'icon': Icons.flight, 'color': AppColors.offWhiteColor2},
    {'name': 'Education', 'icon': Icons.school, 'color': AppColors.offWhiteColor2},
    {'name': 'Entertainment', 'icon': Icons.sports_esports, 'color': AppColors.offWhiteColor2},
    {'name': 'Utilities', 'icon': Icons.bolt, 'color': AppColors.offWhiteColor2},
    {'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': AppColors.offWhiteColor2},
    {'name': 'Gifts & Donations', 'icon': Icons.volunteer_activism, 'color': AppColors.offWhiteColor2},
    {'name': 'Others', 'icon': Icons.more_horiz, 'color': AppColors.offWhiteColor2, 'isMore': true},
  ];

  final List<Map<String, dynamic>> hiddenCategories = [
    {'name': 'Investments', 'icon': Icons.trending_up, 'color': AppColors.offWhiteColor2},
    {'name': 'Personal Care', 'icon': Icons.face, 'color': AppColors.offWhiteColor2},
    {'name': 'Insurance', 'icon': Icons.verified_user, 'color': AppColors.offWhiteColor2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Select Category',
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Text(
              'Choose a category to assign to your recent data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
           SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              return _buildCategoryItem(
                name: categories[index]['name'],
                icon: categories[index]['icon'],
                backgroundColor: categories[index]['color'],
                onTap: () {
                  if (categories[index]['isMore'] == true) {
                    setState(() {
                      categories.removeAt(index);
                      categories.addAll(hiddenCategories);
                      categories.add({
                        'name': 'Less',
                        'icon': Icons.keyboard_arrow_up,
                        'color': AppColors.offWhiteColor2,
                        'isLess': true
                      });
                    });
                  }
                  else if (categories[index]['isLess'] == true) {
                    setState(() {
                      categories.clear();
                      categories.addAll([
                        {'name': 'Food & Dining', 'icon': Icons.restaurant, 'color': AppColors.offWhiteColor2},
                        {'name': 'Transport', 'icon': Icons.directions_car, 'color': AppColors.offWhiteColor2},
                        {'name': 'Shopping', 'icon': Icons.shopping_bag, 'color': AppColors.offWhiteColor2},
                        {'name': 'Housing', 'icon': Icons.home, 'color': AppColors.offWhiteColor2},
                        {'name': 'Health & Wellness', 'icon': Icons.favorite, 'color': AppColors.offWhiteColor2},
                        {'name': 'Travel', 'icon': Icons.flight, 'color': AppColors.offWhiteColor2},
                        {'name': 'Education', 'icon': Icons.school, 'color': AppColors.offWhiteColor2},
                        {'name': 'Entertainment', 'icon': Icons.sports_esports, 'color': AppColors.offWhiteColor2},
                        {'name': 'Utilities', 'icon': Icons.bolt, 'color': AppColors.offWhiteColor2},
                        {'name': 'Groceries', 'icon': Icons.shopping_cart, 'color': AppColors.offWhiteColor2},
                        {'name': 'Gifts & Donations', 'icon': Icons.volunteer_activism, 'color': AppColors.offWhiteColor2},
                        {'name': 'Others', 'icon': Icons.more_horiz, 'color': AppColors.offWhiteColor2, 'isMore': true},
                      ]);
                    });
                  }
                  else {
                    if (kDebugMode) {
                      print('${categories[index]['name']} selected');
                    }

                    // 🚀 FIX: Ab controller mein direct save nahi karenge, balki value back bhejenge!
                    String selectedCatName = categories[index]['name'];
                    Get.back(result: selectedCatName);
                  }
                },
              );
            },
          ),
           SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String name,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 26,
              color:  Color(0xFF1F2937),
            ),
          ),
            SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textColor1,
            ),
          ),
        ],
      ),
    );
  }
}