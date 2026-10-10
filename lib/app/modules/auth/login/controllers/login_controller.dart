

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/storage_service/storage_services.dart';
import '../../../bottom_app_bar/view/bottom_bar.dart';

class LoginController extends GetxController {

  RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisible () {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void setLoading(bool value){
    isLoading.value = value;
  }

  //login with google
  void loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      Get.snackbar(
        "Cancelled",
        "Google Sign-In Cancelled by User",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    if (userCredential.user != null) {
      await StorageServices.setLogin(true);
      Get.snackbar(
        "Success",
        "Google Sign-In Successful",
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAll(() => BottomBar());
    }
  }


  //login with email and password
  void login() async{

    setLoading(true);
    await  _auth
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        await StorageServices.setLogin(true);
        Get.snackbar(
          'Success',
          'User Login Successful',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAll(() => BottomBar());
        setLoading(false);
      })
          .onError((error, stackTrace) {
        Get.snackbar(
          'Error',
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      });
    }
}