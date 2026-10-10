


import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

class BottomBarController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt selectedNav = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Get.put(ProfileController());
  }

  void changeTab(int index){
    if(index >= 0 && index <=3){
      currentIndex.value = index;
      selectedNav.value = index;
    }
  }


  void setFocusTab() {
    selectedNav.value = 4;
  }
   void resetToHome() {
    currentIndex.value = 0;
    selectedNav.value= 0;
   }

}