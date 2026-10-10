import 'dart:io';

import 'package:expense_app/app/modules/transactions/controllers/transaction_controller.dart';
import 'package:expense_app/app/modules/transactions/view/add_transaction.dart';
import 'package:expense_app/helper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/theme/app_colors.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import '../../profile/controllers/profile_controller.dart';
import 'weekly_spending_chart.dart';
import 'monthly_flow_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  final String _adUnitId = 'ca-app-pub-3152663691471360/9385057079';
  final ProfileController controller = Get.put(ProfileController());
  //  TransactionController ko inject kiya taake data access ho sake
  final TransactionController transactionController = Get.put(
    TransactionController(),
  );
  @override
  void initState() {
    super.initState();
    controller.refreshUser();
    _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Ye Test ID hai
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          // Ad load hone ke baad listener set karein
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              // Jab ad band ho jaye, tab user ko navigate karein
              _navigateToNextScreen();
              _interstitialAd!.dispose();
              _loadInterstitialAd(); // Agli baar ke liye nayi ad load karein
            },
          );
        },
        onAdFailedToLoad: (err) {
          if (kDebugMode) print('Failed to load interstitial: ${err.message}');
        },
      ),
    );
  }

  void _navigateToNextScreen() {
    Get.to(() => AddTransaction());
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Helper.bannerUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to Load a Banner ID ${err.toString()}');
          }
          ad.dispose();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F4F5),
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
          style: GoogleFonts.inter(
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
          if (_isAdLoaded && _bannerAd != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          SizedBox(height: 10),
          Obx(
            () => Text(
              'Good Morning, ${controller.userName.value} 👋',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 32,
                color: AppColors.blackColor,
              ),
            ),
          ),
          SizedBox(height: 48),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: AppColors.onboardGreenColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Balance',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor_10,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => Text(
                        '\$${transactionController.totalBalance.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 48,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          // width: 143,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: AppColors.offWhiteColor,
                            border: Border.all(color: AppColors.offWhiteColor),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      color: AppColors.lightGreenColor,
                                    ),
                                    Text(
                                      'Income',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.lightGreenColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  //  Total Income Dynamic Check
                                  child: Obx(
                                    () => Text(
                                      '\$${transactionController.totalIncome.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 24,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          // width: 143,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: AppColors.offWhiteColor,
                            border: Border.all(color: AppColors.offWhiteColor),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: AppColors.expenseColor,
                                    ),
                                    Text(
                                      'Expense',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.expenseColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  //  Total Expense Dynamic Check
                                  child: Obx(
                                    () => Text(
                                      '\$${transactionController.totalExpense.toStringAsFixed(2)}',
                                      style: GoogleFonts.inter(
                                        fontSize: 24,
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    // width: 143,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: AppColors.offWhiteColor,
                      border: Border.all(color: AppColors.offWhiteColor),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icons/saving.png',
                                width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Savings',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            // Savings Dynamic Check
                            child: Obx(
                              () => Text(
                                '\$${transactionController.totalSavings.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.offWhiteColor1),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Categories',
                    style: GoogleFonts.inter(
                      color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                    decoration: inset.BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        inset.BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                          inset: true,
                        ),
                      ],
                    ),
                    child: Text(
                      '100%',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                //  DYNAMIC CATEGORIES LOOP LOGIC
                Obx(() {
                  final percentage = transactionController.categoryPercentage;

                  if (percentage.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'No Expenses recorded yet',
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: percentage.entries.map((entry) {
                      //  Dynamic Color Assignment Matrix
                      Color dotColor;
                      switch (entry.key.toLowerCase().trim()) {
                        case 'food':
                          dotColor = AppColors.onboardGreenColor;
                          break;
                        case 'transport':
                          dotColor = AppColors.greenColor;
                          break;
                        case 'shopping':
                          dotColor = AppColors.offGreyColor;
                          break;
                        case 'personal':
                          dotColor =
                              Colors.blueAccent; // Personal ke liye safe color
                          break;
                        case 'bills':
                          dotColor = Colors.redAccent;
                          break;
                        default:
                          dotColor = AppColors
                              .offGreyColor2; // Fallback automatic color
                      }

                      return ListTile(
                        leading: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: dotColor,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                        ),
                        title: Text(
                          entry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        trailing: Text(
                          '${entry.value.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 10, // Khas gap taake UI clean lage
                        minVerticalPadding: 0,
                        minTileHeight: 38,
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.offWhiteColor1),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weekly Spending',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                WeeklySpendingChart(),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.offWhiteColor1),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Monthly Flow',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.onboardGreenColor,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Inc'),
                    SizedBox(width: 15),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.offGreyColor2,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text('Exp'),
                  ],
                ),
                SizedBox(height: 20),
                MonthlyFlowChart(),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.onboardGreenColor,
        onPressed: () async {
          await FirebaseAnalytics.instance.logEvent(
            name: 'add_transaction_click',
            parameters: {
              'name': 'home_tab',
              'action_type': 'navigate_to_add_transaction_screen',
            },
          );
          // Get.to(() => AddTransaction());
          // Ad logic: Agar ad load hai to dikhao, warna seedha navigate karo
          if (_interstitialAd != null) {
            _interstitialAd!.show();
          } else {
            _navigateToNextScreen();
          }
        },
        child: Icon(Icons.add, color: AppColors.whiteColor),
      ),
    );
  }
}
