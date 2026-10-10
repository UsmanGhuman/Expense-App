


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CardController extends GetxController {
  RxBool switchContoller = false.obs;
  RxString  cardNumber = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString expiryDate = ''.obs;

  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();

  @override
  void onClose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardHolderNameController.dispose();
    // TODO: implement onClose
    super.onClose();
  }

  // RxBool isDefaultCard = false.obs;
  void setNotification(bool value){
    switchContoller.value = value;
  }
}