

import 'package:hive/hive.dart';
part 'goal_model.g.dart';

@HiveType(typeId: 0)
class GoalModel extends HiveObject {
  
  @HiveField(0)
  String name;
  
  @HiveField(1)
  double targetAmount;
  
  @HiveField(2)
  String targetDate;
  
  @HiveField(3)
  String category;
  
  @HiveField(4)
  double savedAmount;

  GoalModel({
    required this.name,
    required this.targetAmount,
    required this.targetDate,
    required this.category,
    required this.savedAmount,
  });
}
