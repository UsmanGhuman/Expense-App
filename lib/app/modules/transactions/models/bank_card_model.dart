

import 'package:hive/hive.dart';
part 'bank_card_model.g.dart';

@HiveType(typeId: 3)
class BankCardModel extends HiveObject{

  @HiveField(0)
  final String cardNumber;

  @HiveField(1)
  final String expiryDate;

  @HiveField(2)
  final String cardHolderName;

  @HiveField(3)
  final String balance;

  BankCardModel({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    this.balance = "\$1,200.00",
  });
}
