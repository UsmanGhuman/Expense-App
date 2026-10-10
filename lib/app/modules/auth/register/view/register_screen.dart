
import 'package:expense_app/app/core/theme/app_colors.dart';
import 'package:expense_app/app/modules/auth/login/view/login_screen.dart';
import 'package:expense_app/app/modules/auth/register/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final RegisterController registerController = Get.put(RegisterController());

  final registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFF3F4F5),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(height: Get.height, width: Get.width),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * .40,
                decoration: BoxDecoration(
                  color: AppColors.onboardGreenColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'Ethos.',
                    style: GoogleFonts.inter(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding:  EdgeInsets.only(bottom: 20),
                  margin:  EdgeInsets.only(top: 20, right: 20, left: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      // spacing: 2,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Create Account',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          'Join Ethos Finance to manage your\n wealth',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 16,color: AppColors.textColor1),
                        ),
                        SizedBox(height: 7),
                        Form(
                          key: registerFormKey,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Full Name',style: GoogleFonts.inter(fontSize: 12,fontWeight: FontWeight.w600,color: AppColors.textColor1),),
                                  TextFormField(
                                    controller: registerController.nameController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person_outline_sharp,
                                        color: AppColors.greishColor,
                                      ),
                                      hintText: 'Alex Morgan',
                                      hintStyle: GoogleFonts.inter(color: AppColors.offGreyColor3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email',style: GoogleFonts.inter(fontWeight: FontWeight.w600,fontSize: 12,color: AppColors.blackColor),),
                                  TextFormField(
                                    controller: registerController.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.greishColor,
                                      ),
                                      hintText: 'alex@gmail.com',
                                      hintStyle: GoogleFonts.inter(color: AppColors.offGreyColor3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your Email';
                                      }
                                      final emailRegex = RegExp(
                                        r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      );

                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 7),
                              SizedBox.expand(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Password',style: GoogleFonts.inter(fontSize: 12,fontWeight: FontWeight.w600,color: AppColors.blackColor),),
                                  Obx(()=>TextFormField(
                                    controller: registerController.passwordController,
                                    obscureText:  !registerController.isPasswordVisible.value,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: AppColors.greishColor,
                                      ),
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            registerController.togglePasswordVisible();
                                          },
                                          child: registerController.isPasswordVisible.value
                                              ? Icon(Icons.visibility_outlined) : Icon(Icons.visibility_off_outlined)
                                      ),
                                      hintText: '••••••••',
                                      hintStyle: GoogleFonts.inter(color: AppColors.offGreyColor3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter Your password';
                                      }
                                      if (!value.contains(RegExp(r'[A-Z]'))) {
                                        return 'Password must contain at least 1 uppercase letter';
                                      }
                                      return null;
                                    },
                                  )),
                                ],
                              ),
                              SizedBox(height: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Confirm Password',style: GoogleFonts.inter(color: AppColors.blackColor,fontWeight: FontWeight.w600,fontSize: 12),),
                                  Obx(()=>TextFormField(
                                    controller: registerController.confirmPasswordController,
                                    obscureText: !registerController.isConfirmPasswordVisible.value,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock_reset_outlined,
                                        color: AppColors.greishColor,
                                      ),
                                      suffixIcon: Obx((){
                                        return InkWell(
                                            onTap: () {
                                              registerController.toggleConfirmPasswordVisible();
                                            },
                                            child: registerController.isConfirmPasswordVisible.value
                                                ? Icon(Icons.visibility_outlined) : Icon(Icons.visibility_off_outlined)
                                        );
                                      }),
                                      hintText: '••••••••',
                                      hintStyle: GoogleFonts.inter(color: AppColors.offGreyColor3),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                          AppColors.loginFiledBorderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirm password';
                                      }
                                      if (value != registerController.passwordController.text) {
                                        return 'Password do not match';
                                      }
                                      return null;
                                    },
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            maximumSize: Size(Get.width, 54),
                            minimumSize: Size(Get.width, 54),
                          ),
                          onPressed: () {
                            if(registerFormKey.currentState!.validate()){
                            registerController.register();
                            }
                          },
                          child: Obx(()=>registerController.isLoading.value
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                        ),),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text('Already have an account?',style: GoogleFonts.inter(color: AppColors.blackColor,fontSize: 16),),
                            InkWell(
                              onTap: () {
                                Get.offAll(() => LoginScreen());
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
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
          ],
        ),
      ),
    );
  }
}





