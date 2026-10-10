import 'package:flutter/material.dart';
import 'package:expense_app/app/core/theme/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;       // 🔥 Ab check bahar se aayega
  final VoidCallback onTap;    // 🔥 Tap ka function bhi bahar se aayega

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,  // Required kar diya
    required this.onTap,       // Required kar diya
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Direct pass kar diya
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.onboardGreenColor.withAlpha(20)
              : AppColors.whiteColor,
          border: Border.all(
            color: isSelected
                ? AppColors.onboardGreenColor
                : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(16), // Agar figma me radius hai toh
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? AppColors.onboardGreenColor : Colors.grey.shade600,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.onboardGreenColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}