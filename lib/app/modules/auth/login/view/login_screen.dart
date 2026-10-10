import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/auth/login/controllers/login_controller.dart';
import 'package:expense_app/app/modules/auth/register/view/register_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.put(LoginController());
  final loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.emailController.clear();
    controller.passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(width: Get.width, height: Get.height),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/login.png', fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/conatiner.png',
                          width: 64,
                          height: 64,
                        ),
                        Text(
                          'Welcome back',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        Text(
                          'Securely access your portfolio',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: AppColors.lightGreenColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Column(
                          spacing: 10,
                          children: [
                            Form(
                              key: loginFormKey,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Email Address',style: GoogleFonts.inter(color: AppColors.textColor1),),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    textAlignVertical: TextAlignVertical.center,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controller.emailController,
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'name@gmail.com',
                                      hintStyle: GoogleFonts.inter(
                                        color: AppColors.hintColor,
                                        fontSize: 16,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.greishColor,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Email';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[\w.-]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Enter a valid Email';
                                      }
                                      return null;
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Password',style: GoogleFonts.inter(color: AppColors.textColor1),),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text('Forget?',style: GoogleFonts.inter(color: AppColors.onboardGreenColor,)),
                                      ),
                                    ],
                                  ),
                                  Obx(() {
                                    return TextFormField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      controller: controller.passwordController,
                                      obscureText:
                                          !controller.isPasswordVisible.value,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: '••••••••',
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintStyle: GoogleFonts.inter(
                                          color: AppColors.hintColor,
                                          fontSize: 16,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () {
                                            controller.togglePasswordVisible();
                                          },
                                          child:
                                              controller.isPasswordVisible.value
                                              ? Icon(Icons.visibility_outlined,color: AppColors.greishColor,)
                                              : Icon(
                                                  Icons.visibility_off_outlined,
                                                color: AppColors.greishColor,
                                                ),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: AppColors.greishColor,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Enter Your Password';
                                        }
                                        if (!value.contains(RegExp(r'[A-Z]'))) {
                                          return 'Password must contain at least 1 uppercase letter';
                                        }
                                        return null;
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    return ElevatedButton(
                                      onPressed: () {
                                        if (loginFormKey.currentState!
                                            .validate()) {
                                          controller.login();
                                        }
                                      },
                                      child: controller.isLoading.value
                                          ? SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 4,
                                                color: AppColors.whiteColor,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('Login Securely',style: GoogleFonts.inter(fontWeight: FontWeight.w500,fontSize: 14),),
                                                Icon(Icons.arrow_forward),
                                              ],
                                            ),
                                    );
                                  }),
                                ),
                                Image.asset(
                                  'assets/images/biometric.png',
                                  width: 56,
                                  height: 56,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: Divider(color: AppColors.dividerColor),
                                ),
                                Text(
                                  'OR CONNECT VIA',
                                  style: GoogleFonts.inter(
                                    color: AppColors.connectColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: AppColors.dividerColor),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(Get.width, 54),
                                minimumSize: Size(Get.width, 54),
                                backgroundColor: AppColors.whiteColor,
                                foregroundColor: AppColors.blackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: AppColors.continueGoogleBorderColor,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                controller.loginWithGoogle();
                              },
                              icon: Image.asset(
                                'assets/icons/google_icons.png',
                                width: 24,
                                height: 24,
                              ),
                              label: Text(
                                'Continue With Google',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.continueGoogleColor,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                maximumSize: Size(Get.width, 54),
                                minimumSize: Size(Get.width, 54),
                                backgroundColor: AppColors.whiteColor,
                                foregroundColor: AppColors.blackColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(
                                    color: AppColors.continueGoogleBorderColor,
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/icons/apple.png',
                                width: 120,
                                height: 32,
                              ),
                              label: Text(
                                'Continue With Apple',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: AppColors.continueGoogleColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Text('New to Ethos?',style: GoogleFonts.inter(color: AppColors.textColor1,fontWeight: FontWeight.w400,fontSize: 16),),
                                InkWell(
                                  onTap: () {
                                    Get.off(() => RegisterScreen());
                                  },
                                  child: Text(
                                    'Create an account',
                                    style: GoogleFonts.inter(
                                      color: AppColors.onboardGreenColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
