import 'package:flutter/material.dart';

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Food':
    case 'Food & Dining':
      return Icons.restaurant;
    case 'Transport':
      return Icons.directions_car;
    case 'Shopping':
      return Icons.shopping_bag;
    case 'Housing':
      return Icons.home;
    case 'Health & Wellness':
      return Icons.favorite;
    case 'Travel':
      return Icons.flight;
  // 🎯 ADDED NEW CASES FROM MORE SCREEN:
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
      return Icons.category; // Yeh hamesha end par backup rahega
  }
}