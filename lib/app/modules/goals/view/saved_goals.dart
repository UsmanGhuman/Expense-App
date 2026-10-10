import 'dart:io';

import 'package:expense_app/app/modules/goals/controllers/new_goal_controller.dart';
import 'package:expense_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/theme/app_colors.dart';
import 'new_goal.dart';

class SavedGoals extends StatefulWidget {
  const SavedGoals({super.key});

  @override
  State<SavedGoals> createState() => _SavedGoalsState();
}

class _SavedGoalsState extends State<SavedGoals> {

  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  final String _nativeAdUnitId = 'ca-app-pub-3940256099942544/2247696110'; // Test ID


  final ProfileController controller = Get.find<ProfileController>();
  final NewGoalController goalController = Get.put(NewGoalController());
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Icon dhoondne ka logic
  IconData getSavedGoalIcon(String catName) {
    switch (catName) {
      case 'Travel':
        return Icons.flight;
      case 'Home':
        return Icons.home;
      case 'Vehicle':
        return Icons.directions_car;
      case 'Hardware':
        return Icons.important_devices;
      case 'Food & Dining':
        return Icons.restaurant;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Health & Wellness':
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
        return Icons.category;
    }
  }
  @override
  void initState() {
    super.initState();
    _loadNativeAd();
  }
  @override
  void dispose() {
    _nativeAd?.dispose(); // Add this
    super.dispose();
  }

void _loadNativeAd() {
  _nativeAd = NativeAd(
    adUnitId: 'ca-app-pub-3940256099942544/2247696110',
    request: AdRequest(),
    nativeTemplateStyle: NativeTemplateStyle(
      templateType: TemplateType.medium,
      mainBackgroundColor: Colors.white,
    ),
    listener: NativeAdListener(
      onAdLoaded: (ad) {
        if (mounted) setState(() => _isNativeAdLoaded = true);
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    ),
  )..load();
}
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 15),
          child: Obx(() {
            return CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: controller.imagePath.value.isNotEmpty
                  ? FileImage(File(controller.imagePath.value))
                  : null,
              foregroundImage: controller.imagePath.isEmpty
                  ? AssetImage('assets/icons/profile1.png')
                  : null,
            );
          }),
        ),
        title: Text(
          'Ethos Finance',
          style: TextStyle(
            color: AppColors.onboardGreenColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 26),
            child: Icon(
              Icons.notifications_none_outlined,
              color: AppColors.onboardGreenColor,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(height: 15),
          Text(
            'Saving Goals',
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w700),
          ),
          Text(
            'Track Your Progress and build your \nfuture',
            style: TextStyle(fontSize: 16, color: AppColors.textColor1),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  maximumSize: Size(130, 44),
                  minimumSize: Size(130, 44),
                ),
                onPressed: () async {
                  await analytics.logEvent(
                    name: 'new_goal_button',
                    parameters: {
                      'name': 'new_goal',
                      'function': 'move_to_new_goal_screen',
                    },
                  );
                  Get.to(() => NewGoal());
                },
                label: Text('New Goal'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          SizedBox(height: 20),
          Obx(() {
            if (goalController.savedGoalsList.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'No Saving Goals yet.\nClick "New Goal" to get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.greishColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                ...List.generate(goalController.savedGoalsList.length, (index) {
                  final goal = goalController.savedGoalsList[index];

                  double target = goal.targetAmount;
                  double saved = goal.savedAmount;
                  double progressValue = target > 0 ? (saved / target) : 0.0;

                  IconData goalIcon = getSavedGoalIcon(goal.category);

                  return Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(
                      24,
                    ), // Exact 24 padding from all 4 sides
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(color: AppColors.offWhiteColor1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX: Header Row with flat alignment, no extra padding margins
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.slayColor,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Icon(
                                goalIcon,
                                color: AppColors.onboardGreenColor,
                                size: 24,
                              ),
                            ),


                            // Zero padding menu trigger using GestureDetector + showMenu
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapDown: (TapDownDetails details) {
                                final RenderBox overlay =
                                    Overlay.of(
                                          context,
                                        ).context.findRenderObject()
                                        as RenderBox;

                                showMenu<String>(
                                  context: context,
                                  position: RelativeRect.fromRect(
                                    details.globalPosition & Size(40, 40),
                                    Offset.zero & overlay.size,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: AppColors.blackColor,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: AppColors.redColor,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: AppColors.redColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ).then((value) {
                                  if (value == 'edit') {
                                    goalController.isEditing.value = true;
                                    goalController.editingIndex = goal.key;
                                    goalController.selectedCategory.value =
                                        goal.category;
                                    goalController.hasText.value =
                                        goal.targetAmount > 0;
                                    Get.to(() => NewGoal(goalModel: goal));
                                  } else if (value == 'delete') {
                                    goalController.deleteGoal(index);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 8,
                                ), // Right alignment kept flat at 0
                                child: Icon(
                                  Icons.more_vert,
                                  color: AppColors.textColor1,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          goal.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                          ),
                        ),
                        Text(
                          'Target Date: ${goal.targetDate}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.greishColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${saved.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'of \$${target.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.textColor1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                minHeight: 10,
                                backgroundColor: AppColors.offWhiteColor2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.onboardGreenColor,
                                ),
                                borderRadius: BorderRadius.circular(5),
                                value: progressValue > 1.0
                                    ? 1.0
                                    : progressValue,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  );

                }),
                // Goals List ke neeche ya beech mein jahan aapka dil kare
                if (_isNativeAdLoaded && _nativeAd != null)
                  Container(
                    height: 350,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: AdWidget(ad: _nativeAd!),
                  ),
              ],
            );
          }),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
