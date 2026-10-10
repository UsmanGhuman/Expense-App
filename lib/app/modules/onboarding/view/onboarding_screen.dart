import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/storage_service/storage_services.dart';
import '../../auth/login/view/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Obx(() {
          return controller.currentIndex.value == 2
              ? IconButton(
                  style: IconButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    controller.previousPage();
                  },
                  icon: Icon(Icons.arrow_back),
                )
              : SizedBox();
        }),
        centerTitle: true,
        title: Obx(() {
          return controller.currentIndex.value == 0
              ? Text(
                  'Ethos Finance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onboardGreenColor,
                  ),
                )
              : SizedBox();
        }),

        actions: [
          Obx(() {
            return controller.currentIndex.value == 1
                ? TextButton(
                    onPressed: () {
                      controller.skip();
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.onboardGreenColor,
                        fontSize: 14,
                      ),
                    ),
                  )
                : SizedBox();
          }),
        ],
      ),
      body: PageView.builder(
        controller: controller.pageController,
        itemCount: controller.imageList.length,
        onPageChanged: (index) {
          controller.onPageChanged(index);
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 10,),
                Image.asset(
                  controller.imageList[index]['image_path'] ?? '',
                  fit: BoxFit.contain,
                ),
                Column(
                  children: [
                    Text(
                      controller.contentList[index]['title'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                    Text(
                      controller.contentList[index]['description'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right : 20,bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              ()  {
                return controller.currentIndex.value == 0 || controller.currentIndex.value == 2
                    ?Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    bool isActive = controller.currentIndex.value == index;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: isActive ? 20 : 7,
                      height: 7,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isActive
                            ? AppColors.onboardGreenColor
                            : AppColors.greyColor,
                      ),
                    );
                  }),
                ) : SizedBox();
              }
            ),
            SizedBox(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() {
                  int currentIndex = controller.currentIndex.value;
                  if (currentIndex == 0) {
                    return InkWell(
                      onTap: (){
                        controller.skip();
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.textColor1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }
                  else if(currentIndex == 1){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        bool isActive = controller.currentIndex.value == index;
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: isActive ? 20 : 7,
                          height: 7,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isActive
                                ? AppColors.onboardGreenColor
                                : AppColors.greyColor,
                          ),
                        );
                      }),
                    );
                  }
                  else{
                    return Padding(
                      padding:  EdgeInsets.symmetric(vertical: 5),
                      child: ElevatedButton(
                        style:   ElevatedButton.styleFrom(
                          backgroundColor: AppColors.onboardGreenColor,
                          foregroundColor: AppColors.whiteColor,
                          minimumSize: Size(Get.width-40,52),
                          maximumSize: Size(Get.width-40, 52)
                        ),
                          onPressed: () async{
                            await StorageServices.setOnboarding(true);

                            Get.offAll(()=>LoginScreen());
                          },
                          child: Text('Get Started',style: TextStyle(fontSize: 14),)),
                    );
                  }
                }),

                Obx((){
                  int currentIndex = controller.currentIndex.value;
                  if(currentIndex == 0){
                    return ElevatedButton(
                      onPressed: () {
                        controller.nextPage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.onboardGreenColor,
                        foregroundColor: AppColors.whiteColor,
                      ),
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    );
                  }
                  else if (currentIndex == 1){
                    return IconButton(
                      onPressed: () {
                        controller.nextPage();
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.onboardGreenColor,
                        foregroundColor: AppColors.whiteColor,
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_forward),
                      ),
                    );
                  }
                  else{
                    return SizedBox();
                  }
                })
              ],
            ),
          ],
        ),
      ),
    );
  }
}
