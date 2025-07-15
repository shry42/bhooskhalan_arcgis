
import 'package:bhooskhalann/screens/homescreen.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicLoginController extends GetxController {
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isRememberMe = false.obs;

  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  ProfileController pc = ProfileController();

    @override
  void onInit() {
    super.onInit();
    loadRememberedCredentials();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }


void toggleRememberMe(bool? value) {
    isRememberMe.value = value ?? false;
  }

  Future<void> loadRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMobile = prefs.getString('rememberMobilePublic') ?? '';
    final savedPassword = prefs.getString('rememberPasswordPublic') ?? '';

    if (savedMobile.isNotEmpty && savedPassword.isNotEmpty) {
      mobileController.text = savedMobile;
      passwordController.text = savedPassword;
      isRememberMe.value = true;
      pc.fetchUserProfile();
    }
  }

 void login() async {
  final mobile = mobileController.text.trim();
  final password = passwordController.text.trim();
  const usertype = "Public";

  if (mobile.isEmpty || password.isEmpty) {
   Get.snackbar('error'.tr, 'please_enter_mobile_password'.tr);
    return;
  }

  isLoading.value = true;

  try {
    final endpoint =
        '/Login/tocken?mobile=$mobile&password=$password&usertyp=$usertype';
    
    final response = await ApiService.put(endpoint);

    if (response['status'] == 'Success') {
      final token = response['token'];
        
        // Store token and mobile number using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('mobile', mobile);
        await prefs.setString('userType', "Public");

          // Save credentials if Remember Me is checked
        if (isRememberMe.value) {
          await prefs.setString('rememberMobilePublic', mobile);
          await prefs.setString('rememberPasswordPublic', password);
        } else {
          await prefs.remove('rememberMobilePublic');
          await prefs.remove('rememberPasswordPublic');
        }


      Get.snackbar('success'.tr, 'login_successful'.tr);
      Get.offAll(() => HomeScreen());
    } else {
      Get.snackbar('login_failed'.tr, response['message'] ?? 'unknown_error'.tr);
    }
  } catch (e) {
    Get.snackbar('error'.tr, '${'something_went_wrong'.tr}: $e');
  } finally {
    isLoading.value = false;
  }
}

  @override
  void onClose() {
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
