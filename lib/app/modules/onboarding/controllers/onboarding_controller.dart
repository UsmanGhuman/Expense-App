import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  List<Map<String, dynamic>> imageList = [
    {'id': 1, 'image_path': 'assets/images/slider4.png'},
    {'id': 2, 'image_path': 'assets/images/slider2.png'},
    {'id': 3, 'image_path': 'assets/images/slider3.png'},
  ];

  List<Map<String, String>> contentList = [
    {'title': 'Manage all your Expenses in one place', 'description': ''},
    {
      'title': 'Visualize your spending habits',
      'description':
          'Get clear, elegant insights into where your money goes.No more guessing,just effortless control over your finances.',
    },
    {
      'title': 'Reach your financial goals faster',
      'description':
          'Set meticulous targets, track your portfolio\'s  progress effortlessly, and build lasting wealth with quite confidence',
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < imageList.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void skip() {
    pageController.animateToPage(
      imageList.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  int get totalPages => imageList.length;
}
