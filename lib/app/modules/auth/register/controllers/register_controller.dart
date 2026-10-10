

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../login/view/login_screen.dart';

class RegisterController extends GetxController{
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

  void togglePasswordVisible () {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  void toggleConfirmPasswordVisible () {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  RxBool isLoading = false.obs;
  void setLoading(bool value){
    isLoading.value = value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void register() async{

      setLoading(true);
      await _auth
          .createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Success Message',
          'User Created Successfully',
        );
        String uid = value.user!.uid;
        firestore.doc(uid).set({
          'uid': uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
        });
        setLoading(false);
        Get.off(() => LoginScreen());
      })
          .onError((error, stackTrace) {
        Get.snackbar(
          snackPosition: SnackPosition.BOTTOM,
          'Error',
          error.toString(),
        );
        setLoading(false);
      });
    }

}