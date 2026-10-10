import 'package:expense_app/app/modules/transactions/view/my_transaction_cards.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../analytics/view/analytics_screen.dart';
import '../../home/view/home_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../controllers/bottom_bar_controller.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final BottomBarController controller = Get.put(BottomBarController());
  final List<Widget> pages = [HomeScreen(),MyTransactionCards(),AnalyticsScreen(),ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Obx((){
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result){
          if(controller.currentIndex.value != 0){
            controller.resetToHome();
          }else{
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          body: pages[controller.currentIndex.value],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(16),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset:  Offset(0, -4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(24.0),  // Top Left Round
                topRight: Radius.circular(24.0), // Top Right Round
              ),
              child: BottomAppBar(
                color: AppColors.whiteColor,
                child: SizedBox(
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navItem('assets/icons/home.png','Home',0),
                      navItem('assets/icons/transaction.png','Transactions',1),
                      navItem('assets/icons/analytics.png','Analytics',2),
                      navItem('assets/icons/persons.png','Profile',3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
  Widget navItem(String imagePath, String label, int index) {
    return Obx(() {
      bool isSelected = controller.selectedNav.value == index;

      return GestureDetector(
        onTap: () async{
         await FirebaseAnalytics.instance.logEvent(
              name: 'bottom_nav',
            parameters: {
                'tab_name' : label,
              'tab_index': index,
              'function':'switch_between_bottom_tabs'
            }
          );
          controller.changeTab(index);
          },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath,width: 24,height: 24,scale: 4, color: isSelected ? AppColors.onboardGreenColor : Colors.grey),
            Text(
              label,
              style: TextStyle(color: isSelected ? AppColors.onboardGreenColor : Colors.grey),
            ),
          ],
        ),
      );
    });
  }
}


