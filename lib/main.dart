import 'package:expense_app/app/core/services/storage_service/storage_services.dart';
import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/analytics/models/budget_model.dart';
import 'package:expense_app/app/modules/auth/login/view/login_screen.dart';
import 'package:expense_app/app/modules/bottom_app_bar/view/bottom_bar.dart';
import 'package:expense_app/app/modules/goals/models/goal_model.dart';
import 'package:expense_app/app/modules/splash/view/splash_screen.dart';
import 'package:expense_app/app/modules/transactions/models/bank_card_model.dart';
import 'package:expense_app/app/modules/transactions/models/transaction_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['C34E8B09EB35E58AC0FE90D6CEFF7CE9']),
  );
  MobileAds.instance.initialize();

  final seenOnboarding = await StorageServices.getOnboarding();
  final isLoggedIn = await StorageServices.getLogin();

  await Hive.initFlutter();
  await Hive.openBox('profileBox');

  Hive.registerAdapter(GoalModelAdapter());
  await Hive.openBox<GoalModel>('goalBox');

  Hive.registerAdapter(BudgetModelAdapter());
  await Hive.openBox<BudgetModel>('budgetBox');

  Hive.registerAdapter(BankCardModelAdapter());
  await Hive.openBox<BankCardModel>('bankCard');

  Hive.registerAdapter(TransactionModelAdapter());
  await Hive.openBox<TransactionModel>('transaction_box');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp(seenOnboarding: seenOnboarding, isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool isLoggedIn;
  const MyApp({
    super.key,
    required this.seenOnboarding,
    required this.isLoggedIn,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ethos Finance',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.onboardGreenColor,
        ),
        inputDecorationTheme: InputDecorationThemeData(
          filled: true,
          fillColor: AppColors.blackFilledColor,
          focusedErrorBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColors.loginFiledBorderColor, width: 2.0), // Halka sa thick red border padding ke liye
            borderRadius: BorderRadius.circular(24),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: AppColors.loginFiledBorderColor, width: 1.5), // Same style, Red color
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.loginFiledBorderColor),
            borderRadius: BorderRadius.circular(24)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.loginFiledBorderColor),
            borderRadius: BorderRadius.circular(24)
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.onboardGreenColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: !seenOnboarding
          ? SplashScreen()
          : !isLoggedIn
          ? LoginScreen()
          : BottomBar(),
    );
  }
}
