import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'transaction_model.g.dart'; //  Generator ke liye laazmi hai

@HiveType(typeId: 4)
class TransactionModel extends HiveObject{
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String time;

  @HiveField(4)
  final double amount;

  @HiveField(5)
  final bool isIncome;

  @HiveField(6)
  final String cardName;

  //  Hive ke liye hum primitive data types (integers) save kar rahe hain
  @HiveField(7)
  final int iconCodePoint;

  @HiveField(8)
  final int iconColorValue;

  @HiveField(9)
  final int iconBgColorValue;

  TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.isIncome,
    required this.cardName,
    required this.iconCodePoint,
    required this.iconColorValue,
    required this.iconBgColorValue,
  });

  //  UI Getters: Inki wajah se aapke poore project ke UI widgets mein (.icon, .iconColor, .iconBgColor) bilkul pehle ki tarah milta rahega!
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get iconColor => Color(iconColorValue);
  Color get iconBgColor => Color(iconBgColorValue);
}