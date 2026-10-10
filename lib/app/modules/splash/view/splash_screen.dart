import 'dart:async';
import 'dart:ui';

import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/onboarding/view/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/services/storage_service/storage_services.dart';
import '../../auth/login/view/login_screen.dart';
import '../../home/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAppStatus();
    // Timer(Duration(seconds: 5), () {
    //   Get.to(OnboardingScreen());
    // });
  }
  void checkAppStatus() async {
    // splash delay (keep short for better UX)
    await Future.delayed(const Duration(seconds: 2));

    final seenOnboarding = await StorageServices.getOnboarding();
    final isLoggedIn = await StorageServices.getLogin();

    if (!seenOnboarding) {
      Get.offAll(() => const OnboardingScreen());
    }
    else if (isLoggedIn) {
      Get.offAll(() => const HomeScreen());
    }
    else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.splashColor,
              AppColors.splashColor1,
              AppColors.splashColor2,
            ],
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 83.67,
                height: 29,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(
                    color: AppColors.splashBorderColor.withAlpha(26),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.splashBorderColor.withAlpha(26),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(12, 6, 12, 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(13),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/icons/light.png'),
                          SizedBox(width: 8),
                          Text(
                            'LIGHT',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 100),
            Image.asset(
              'assets/images/splash.png',
              width: 260,
              height: 260,
              fit: BoxFit.contain,
            ),
            ShaderMask(
                shaderCallback: (bounds){
                  return LinearGradient(
                      colors: [
                        AppColors.whiteColor,
                        AppColors.greenColor
                  ]).createShader(Rect.fromLTWH(0, 0, bounds.width-20, bounds.height));
                },
              child: Text('Ethos',style: TextStyle(fontSize: 48,color: Colors.white, fontWeight: FontWeight.bold),),
                ),
            SizedBox(height: 20,),
            Text('Master Your Money\n Own Your Future',style: GoogleFonts.inter(fontSize: 18,color: AppColors.textColor),),
            SizedBox(height: 30,),
            Container(
              height: 46,
              width: 46,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: AppColors.splashBorderColor.withAlpha(26),
                ),
                color: Colors.black.withAlpha(13),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.greenColor),
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
