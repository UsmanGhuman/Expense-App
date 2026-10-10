import 'dart:io';

import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/addCards/view/add_new_card.dart';
import 'package:expense_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:expense_app/app/modules/transactions/controllers/transaction_controller.dart';

import 'package:expense_app/app/modules/transactions/view/my_cards.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTransactionCards extends StatefulWidget {
  const MyTransactionCards({super.key});

  @override
  State<MyTransactionCards> createState() => _MyTransactionCardsState();
}

class _MyTransactionCardsState extends State<MyTransactionCards> {
  final ProfileController profileController = Get.find<ProfileController>();
  final TransactionController controller = Get.put(TransactionController());

  late final PageController _pageController;
  final RxInt _currentCardPage = 0.obs;
  //  EXPANSION SWITCH: Yeh track karega ke list poori kholni hai ya nahi
  final RxBool isExpanded = false.obs;

  List<String> elements = [
    'All',
    'Income',
    'Expense',
    'This Month',
    'This Week',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
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
              backgroundImage: profileController.imagePath.value.isNotEmpty
                  ? FileImage(File(profileController.imagePath.value))
                  : null,
              foregroundImage: profileController.imagePath.isEmpty
                  ? AssetImage('assets/icons/profile1.png')
                  : null,
            );
          }),
        ),
        centerTitle: true,
        title: Text(
          'Ethos Finance',
          style: GoogleFonts.inter(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 24,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Cards',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'new_transaction',
                    parameters: {
                      'click_source': 'transaction_screen_button',
                      'action': 'navigate_to_new_card_screen',
                    },
                  );
                  Get.to(() => AddNewCard());
                },
                child: Row(
                  children: [
                    Icon(Icons.add,color: AppColors.onboardGreenColor,),
                    Text(
                      'Add New',
                      style: GoogleFonts.inter(
                        color: AppColors.onboardGreenColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Obx(() {
            if (controller.myCardsList.isEmpty) {
              return SizedBox(
                  height: Get.height * 0.25,
                child: Center(
                  child: Text('No Cards available, Please add a card',style: GoogleFonts.inter(),),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 220,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: controller.myCardsList.length,
                    onPageChanged: (index) {
                      _currentCardPage.value = index;
                      //  CARD SWIPE: Swipe hote hi active card name controller mein update hoga
                      controller.selectedCard.value =
                          controller.myCardsList[index].cardHolderName;
                      //  Reset list view status when user swipes to a different card
                      isExpanded.value = false;
                    },
                    itemBuilder: (context, index) {
                      final card = controller.myCardsList[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(48),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.onboardGreenColor,
                              AppColors.darkColor,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              spreadRadius: -5,
                              offset: Offset(0, 8),
                              color: AppColors.shadowColor.withAlpha(10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Available Balance',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.whiteColor_10,
                                  ),
                                ),
                                Image.asset(
                                  'assets/icons/cardicon1.png',
                                  scale: 4,
                                ),
                              ],
                            ),
                            Text(
                              card.balance,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            Text(
                              card.cardNumber,
                              style: GoogleFonts.inter(
                                color: AppColors.whiteColor,
                                fontSize: 16,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    card.cardHolderName.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.whiteColor_10,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Visa'.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.myCardsList.length,
                    (dotIndex) => Obx(() {
                      bool isSelected = _currentCardPage.value == dotIndex;
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: isSelected
                              ? AppColors.onboardGreenColor
                              : AppColors.greyColor,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            );
          }),
          SizedBox(
            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: elements.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Obx(() {
                  bool isTabSelected = controller.selectedIndex.value == index;
                  return GestureDetector(
                    onTap: () {
                      controller.changeIndex(index); // Update filter tab index
                    },
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.symmetric(horizontal: 22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9999),
                            color: isTabSelected
                                ? AppColors.onboardGreenColor
                                : AppColors.offWhiteColor2,
                          ),
                          child: Center(
                            child: Text(
                              elements[index],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isTabSelected
                                    ? AppColors.whiteColor
                                    : AppColors.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.search),
            ],
          ),
          // DYNAMIC RECENT ACTIVITY (FIXED!)
          Obx(() {
            if (controller.filteredTransactions.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No transactions found for this card.',style: GoogleFonts.inter(),),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: isExpanded.value
                  ? controller.filteredTransactions.length
                  : (controller.filteredTransactions.length > 3
                        ? 3
                        : controller.filteredTransactions.length),
              itemBuilder: (context, index) {
                return MyCards(
                  transaction: controller.filteredTransactions[index],
                );
              },
            );
          }),
          SizedBox(height: 10),
          Obx(() {
            // Agar kul transactions hi 3 ya us se kam hain, toh button mat dikhao
            if (controller.filteredTransactions.length <= 3) {
              return SizedBox(height: 10);
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: AppColors.shadowColor),
                  padding: EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.whiteColor,
                  foregroundColor: AppColors.onboardGreenColor,
                  minimumSize: Size(Get.width, 48),
                ),
                onPressed: () {
                  //  Toggle state click hone par (Sari transactions khul jayengi ya wapas 3 ho jayengi)
                  isExpanded.value = !isExpanded.value;
                },
                // Dynamic text jo button khulne par badal jaye
                child: Text(
                  isExpanded.value ? 'Show Less' : 'View All Activity',
                  style: GoogleFonts.inter(
                    color: AppColors.onboardGreenColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
