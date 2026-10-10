import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  RxString imagePath = ''.obs;
  RxString userName = 'Loading ...'.obs;
  RxBool isLoading = true.obs;

  RxBool isNotificationEnabled = false.obs;
  RxBool isDarkModeEnabled = false.obs;
  void setNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  void toggleDarkMode(bool value) {
    isDarkModeEnabled.value = value;
  }

  //To Save Image In Hive
  final Box _myBox = Hive.box('profileBox');

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestore = FirebaseFirestore.instance.collection('user');
//Saving and Getting name saved in firebase firestore
  @override
  void onInit() {
    super.onInit();
    String? savedPath = _myBox.get('profile_image_path');
    if(savedPath != null && savedPath.isNotEmpty){
      imagePath.value = savedPath;
    }
    bindUserProfileStream();
  }

  void bindUserProfileStream() {
    try {
      String? currentId = _auth.currentUser?.uid;

      if (currentId != null) {
        isLoading.value = true;

        userName.bindStream(
          _firestore.doc(currentId).snapshots().map((snapshot) {

            if (snapshot.exists && snapshot.data() != null) {
              Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
              isLoading.value = false;
              return data['name'] ?? 'No Name';
            } else {

              if (isLoading.value) {
                return 'Loading ...';
              }
              isLoading.value = false;
              return 'User Not Found in DB';
            }
          }),
        );
      } else {
        userName.value = 'No Session';
        isLoading.value = false;
      }
    } catch (e) {
      userName.value = 'Error Loading Name';
      isLoading.value = false;
    }
  }

  void refreshUser() {
    isLoading.value = true;
    bindUserProfileStream();
  }
// Image Related Code
  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path.toString();
      await _myBox.put('profile_image_path', image.path.toString());
    } else {
      Get.snackbar(
        'No Image Selected',
        'Please select an image from gallery',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}