import 'dart:io';

import 'package:expense_app/app/modules/analytics/controllers/budget_controller.dart';
import 'package:expense_app/app/modules/analytics/view/new_budget.dart';
import 'package:expense_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/services/helper/icons_helper.dart' as IconsHelper;
import '../../../core/theme/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  RewardedAd? _rewardedAd;
  final ProfileController controller = Get.put(ProfileController());
  final BudgetController budgetController = Get.put(BudgetController());

  @override
  void initState() {
    super.initState();
    _loadRewardedAd(); // Load the ad when screen opens
  }
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917', // Test ID
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (err) => print('Rewarded failed: ${err.message}'),
      ),
    );
  }


  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
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
                  ? const AssetImage('assets/icons/profile1.png')
                  : null,
            );
          }),
        ),
        title: Text(
          'Ethos Finance',
          style: TextStyle(
            color: AppColors.blackColor,
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
      body: Obx(() {
        if (budgetController.savedBudgetList.isEmpty) {
          return Center(child: Text('No Budget Added yet'));
        }

        double totalBudget = budgetController.totalAmountBudget.value;
        double totalSaved = budgetController.totalSavedAmount.value;
        double overAllPercentage = totalBudget > 0
            ? (totalSaved / totalBudget)
            : 0.0;
        double remainingAmount = totalBudget - totalSaved;

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: 10),
            Text(
              'My Budget',
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Track your Spending against your goals',
              style: GoogleFonts.inter(color: AppColors.textColor1, fontSize: 16),
            ),
            SizedBox(height: 24),
            //1. TOP TOTAL MONTHLY BUDGET CARD
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.offWhiteColor1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Monthly Budget'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textColor1,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${totalSaved.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 48,
                            color: AppColors.blackColor,
                          ),
                        ),
                        TextSpan(
                          text: '/\$${totalBudget.toStringAsFixed(0)}',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            color: AppColors.textColor1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.offGreenColor3,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      '${(overAllPercentage * 100).toStringAsFixed(0)}% spent',
                      style: GoogleFonts.inter(
                        color: AppColors.onboardGreenColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    minHeight: 10,
                    backgroundColor: AppColors.offGreenColor2,
                    borderRadius: BorderRadius.circular(5),
                    value: overAllPercentage.clamp(0.0, 1.0),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$0',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.textColor1,
                        ),
                      ),
                      Text(
                        '\$${remainingAmount.toStringAsFixed(0)} Remaining',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppColors.textColor1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Dynamic Budget List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: budgetController.savedBudgetList.length,
              itemBuilder: (context, index) {
                final budget = budgetController.savedBudgetList[index];

                double budgetPercentage = budget.targetAmount > 0
                    ? (budget.savedAmount / budget.targetAmount)
                    : 0.0;
                double leftAmount = budget.targetAmount - budget.savedAmount;
                bool isOverBudget = budget.savedAmount > budget.targetAmount;

                return Container(
                  margin: EdgeInsets.only(bottom: 24),
                  padding: EdgeInsets.all(
                    24,
                  ), //  Exact 24 padding from all sides
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.offWhiteColor1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  Custom Row for header (ListTile completely replaced here)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9999),
                                    color: isOverBudget
                                        ? AppColors.offRedColor
                                        : AppColors.offGreenColor3,
                                  ),
                                  child: Icon(
                                    IconsHelper.getCategoryIcon(
                                      budget.category,
                                    ),
                                    color: isOverBudget
                                        ? AppColors.redColor
                                        : AppColors.onboardGreenColor,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    budget.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Zero padding menu trigger using GestureDetector + showMenu
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (TapDownDetails details) {
                              final RenderBox overlay =
                                  Overlay.of(context).context.findRenderObject()
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
                                        Icon(Icons.edit, size: 20),
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
                                  Get.to(() => NewBudget(editBudget: budget));
                                } else if (value == 'delete') {
                                  budgetController.deleteBudget(budget);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 8,
                              ), // Right side kept purely 0 flat
                              child: Icon(
                                Icons.more_vert,
                                color: AppColors.textColor1,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '\$${budget.savedAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: isOverBudget
                                    ? AppColors.redColor
                                    : AppColors.blackColor,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '/\$${budget.targetAmount.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${(budgetPercentage * 100).toStringAsFixed(0)} % of budget used',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isOverBudget
                              ? AppColors.redColor
                              : AppColors.textColor1,
                        ),
                      ),
                      SizedBox(height: 16),
                      LinearProgressIndicator(
                        minHeight: 10,
                        backgroundColor: AppColors.offWhiteColor2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOverBudget
                              ? AppColors.redColor
                              : AppColors.onboardGreenColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                        value: budgetPercentage.clamp(0.0, 1.0),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          isOverBudget
                              ? '-\$${leftAmount.abs().toStringAsFixed(0)} over'
                              : '\$${leftAmount.toStringAsFixed(0)} left',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: isOverBudget
                                ? AppColors.redColor
                                : AppColors.onboardGreenColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ad logic: Agar ad loaded hai to dikhao, warna seedha screen par jao
          if (_rewardedAd != null) {
            _rewardedAd!.show(
              onUserEarnedReward: (ad, reward) {
                // Ad poori dekhne ke baad NewBudget screen par le jao
                Get.to(() => NewBudget());
              },
            );
            // Reload for next time
            _rewardedAd = null;
            _loadRewardedAd();
          } else {
            // Agar ad load nahi hui, to seedha navigate karo
            Get.to(() => NewBudget());
          }
        },
        backgroundColor: AppColors.onboardGreenColor,
        icon: Icon(Icons.add, color: AppColors.whiteColor),
        label: Text(
          'Create Budget',
          style: TextStyle(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
