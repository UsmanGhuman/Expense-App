  import 'package:expense_app/app/modules/addCards/controllers/card_controller.dart';
  import 'package:expense_app/app/modules/transactions/controllers/transaction_controller.dart';
  import 'package:expense_app/app/modules/transactions/models/bank_card_model.dart';
  import 'package:firebase_analytics/firebase_analytics.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  
  import '../../../core/theme/app_colors.dart';
  
  class AddNewCard extends StatefulWidget {
    const AddNewCard({super.key});
  
    @override
    State<AddNewCard> createState() => _AddNewCardState();
  }
  
  class _AddNewCardState extends State<AddNewCard> {
    final CardController controller = Get.put(CardController());
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xFFF3F4F5),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Add New Card',
            style: TextStyle(fontSize: 16, color: AppColors.blackColor),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(48),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 40,
                    spreadRadius: -10,
                    offset: Offset(0, 10),
                    color: AppColors.lightGreenColors,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [AppColors.darkGreenColor, AppColors.onboardGreenColor],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/icons/cardicon.png',
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        'credit'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    String displayNum = controller.cardNumber.value.isEmpty
                        ? '**** **** ***** *****'
                        : controller.cardNumber.value;
                    return Text(
                      displayNum,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteColor,
                        letterSpacing: 2,
                      ),
                    );
                  }),
                  SizedBox(height: 10),
                  // Row(
                  //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   spacing: 20,
                  //   children: [
                  //     Text(
                  //       '****',
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w600,
                  //         color: AppColors.whiteColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       '****',
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w600,
                  //         color: AppColors.whiteColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       '****',
                  //       style: TextStyle(
                  //         fontSize: 24,
                  //         fontWeight: FontWeight.w600,
                  //         color: AppColors.whiteColor,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Text(
                  //   '****',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.w600,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CardHolder'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Expires'.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        String displayName =
                            controller.cardHolderName.value.isEmpty
                            ? 'Your Name'
                            : controller.cardHolderName.value.toUpperCase();
                        return Text(
                          displayName,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                      Obx(() {
                        String displayExpiry = controller.expiryDate.value.isEmpty
                            ? 'MM/YY'
                            : controller.expiryDate.value;
                        return Text(
                          displayExpiry,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                border: Border.all(color: AppColors.greyColor),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Card Number', style: TextStyle()),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      maxLength: 16,
                      controller: controller.cardNumberController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.cardNumber.value = value;
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        prefixIcon: Image.asset(
                          'assets/icons/purse.png',
                          scale: 4,
                        ),
                        hintText: '0000 0000 0000 0000',
                        hintStyle: TextStyle(color: AppColors.darkGreyColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text('Expiry Date'),
                        Spacer(),
                        Text('CVV'),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.expiryDateController,
                            onChanged: (value) {
                              controller.expiryDate.value = value;
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              hintStyle: TextStyle(
                                color: AppColors.darkGreyColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller.cvvController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '123',
                              hintStyle: TextStyle(
                                color: AppColors.darkGreyColor,
                              ),
                              suffixIcon: Image.asset(
                                'assets/icons/info.png',
                                scale: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('CardHolder Name', style: TextStyle()),
                    ),
                    SizedBox(height: 5),
                    TextField(
                      controller: controller.cardHolderNameController,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        controller.cardHolderName.value = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'e.g.jhon doe'.toUpperCase(),
                        hintStyle: TextStyle(color: AppColors.darkGreyColor),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.offGreyColor2,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side ka text block (Perfect Alignment)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Set as Default Card',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Use this card for future transactions',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.greishColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
  
                          Obx(
                            () => Switch(
                              trackOutlineColor: WidgetStatePropertyAll(
                                Colors.white,
                              ),
                              inactiveThumbColor: AppColors.whiteColor,
                              inactiveTrackColor: AppColors.greyColor,
                              value: controller.switchContoller.value,
                              onChanged: (value) {
                                controller.setNotification(value);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                if (controller.cardNumberController.text.isEmpty ||
                    controller.expiryDateController.text.isEmpty ||
                    controller.cvvController.text.isEmpty ||
                    controller.cardHolderNameController.text.isEmpty) {
  
                  Get.snackbar(
                    'Error',
                    'Please fill all Card Details',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                if (controller.cardNumberController.text.length != 16) {
                  Get.snackbar(
                    'Invalid Card',
                    'Card Number must be exactly 16 digits long',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'add_card',
                    parameters: {'card_holder': controller.cardHolderName.value},
                  );
                  final TransactionController txController =
                      Get.find<TransactionController>();
  
                  txController.addNewCardToList(
                    BankCardModel(
                      cardNumber: controller.cardNumber.value,
                      expiryDate: controller.expiryDate.value.isEmpty
                          ? 'MM/YY'
                          : controller.expiryDate.value,
                      cardHolderName: controller.cardHolderName.value,
                      balance: "\$0.00",
                    ),
                  );
                  Get.back();
                  Get.snackbar('Message', 'Card Added Successfully',snackPosition: SnackPosition.BOTTOM);
                },
  
              label: Text('Add Card'),
              icon: Icon(Icons.add_circle_outlined),
            ),
            SizedBox(height: 30),
          ],
        ),
      );
    }
  }
