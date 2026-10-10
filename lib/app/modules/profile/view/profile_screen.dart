import 'dart:io';

import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/auth/login/view/login_screen.dart';
import 'package:expense_app/app/modules/goals/view/saved_goals.dart';
import 'package:expense_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/services/storage_service/storage_services.dart';
import '../../bottom_app_bar/controllers/bottom_bar_controller.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void signout() async {
    if (Get.isRegistered<BottomBarController>()) {
      Get.find<BottomBarController>().resetToHome();
    }

    // 2. 🚀 BEST PRACTICE: GetX ki memory dho dein taake saare controllers fresh shuru hon
    Get.deleteAll();
    Get.offAll(() => LoginScreen());
    await GoogleSignIn().signOut();
    await StorageServices.setLogin(false);
    await FirebaseAuth.instance.signOut();
  }

  final ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
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
          style: TextStyle(
            color: AppColors.onboardGreenColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 26),
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
          SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                Obx(() {
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
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () async{
                      await FirebaseAnalytics.instance.logEvent(
                          name: 'add_image',
                        parameters: {
                            'name' : 'choose_image_from_gallery',
                          'function': 'add_profile_image'
                        }
                      );
                      controller.getImage();
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(39),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.edit, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return Text(
                  controller.userName.value,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 28),
                );
              }),
              Text(user?.email ?? 'No Email'),
            ],
          ),
          SizedBox(height: 20),
          newMethod(text: 'Account'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.slayColor2),
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: () async{
                    await FirebaseAnalytics.instance.logEvent(
                        name: 'personal_info',
                      parameters: {
                          'name': 'personal_info_list',
                        'function' : 'move_to_personal_screen'
                      }
                    );
                    Get.to(() => SavedGoals());
                  },
                  child: tilesListTile(
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9999),
                        color: AppColors.onboardColor1,
                      ),
                      child: Image.asset('assets/icons/person.png', scale: 4),
                    ),
                    title: 'Personal Info',
                    subtitle: 'Manage your identity and details',
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 15,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(children: [Expanded(child: Divider())]),
                SizedBox(height: 10),
                tilesListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      color: AppColors.skyColor,
                    ),
                    child: Image.asset('assets/icons/security.png', scale: 4),
                  ),
                  title: 'Security',
                  subtitle: 'Password, 2FA,and devices',
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          newMethod(text: 'Prefrences'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.slayColor2),
            ),
            child: Column(
              children: [
                tilesListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      color: AppColors.slayColor2,
                    ),
                    child: Image.asset('assets/icons/currency.png', scale: 4),
                  ),
                  title: 'Currency',
                  trailing: DropdownMenu(
                    width: 110,
                    inputDecorationTheme: InputDecorationTheme(
                      border: InputBorder.none,
                      iconColor: AppColors.greyColor,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'USD(\$)',
                        label: "USD(\$)",
                      ),
                      DropdownMenuEntry(
                        value: 'UK(£)',
                        label: "UK(£)",
                      ),
                    ],
                  )
                ),
                Row(children: [Expanded(child: Divider())]),
                tilesListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      color: AppColors.slayColor2,
                    ),
                    child: Image.asset(
                      'assets/icons/notification.png',
                      scale: 4,
                    ),
                  ),
                  title: 'Notifications',
                  trailing: Obx((){
                    return Switch(
                      trackOutlineColor: WidgetStatePropertyAll(Colors.white),
                      inactiveThumbColor: AppColors.whiteColor,
                      inactiveTrackColor: AppColors.greyColor,
                      value: controller.isNotificationEnabled.value,
                      onChanged: (value) {
                        controller.setNotification(value);
                      },
                    );
                  })
                ),
                Row(children: [Expanded(child: Divider())]),
                tilesListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      color: AppColors.slayColor2,
                    ),
                    child: Image.asset('assets/icons/moon.png', scale: 4),
                  ),
                  title: 'DarkMode',
                  trailing: Obx((){
                    return Switch(
                      inactiveThumbColor: AppColors.whiteColor,
                      trackOutlineColor: WidgetStatePropertyAll(Colors.white),
                      inactiveTrackColor: AppColors.greyColor,
                      value: controller.isDarkModeEnabled.value,
                      onChanged: (value) {
                        controller.toggleDarkMode(value);
                      },
                    );
                  })
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          newMethod(text: 'Data & Privacy'),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.slayColor2),
            ),
            child: Column(
              children: [
                tilesListTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                      color: AppColors.slayColor2,
                    ),
                    child: Image.asset('assets/icons/export.png', scale: 4),
                  ),
                  title: 'Export Data',
                  subtitle: 'Download your transaction history',
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 15,
                    color: AppColors.greyColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () async{
              await FirebaseAnalytics.instance.logEvent(
                name: 'sign_out',
                parameters: {
                  'name': 'logout_button',
                  'function': 'make_user_logout'
                }
              );
              signout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: AppColors.redColor1),
                Text(
                  ' SignOut',
                  style: TextStyle(
                    color: AppColors.redColor1,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Padding newMethod({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.slayColor1,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  ListTile tilesListTile({
    required Widget leading,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 10,
      minVerticalPadding: 0,
      minTileHeight: 50,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: AppColors.slayColor1),
            )
          : null,
      trailing: trailing,
    );
  }
}
