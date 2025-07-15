import 'package:bhooskhalann/screens/forgot_password_screens/reset_pass_screen.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final mobileController = TextEditingController();
     
  RxBool isLoading = false.obs;
 
  void sendOTP() async {
    final mobile = mobileController.text.trim();
         
    // Validate mobile number
    if (mobile.isEmpty) {
      Get.snackbar('error'.tr, 'please_enter_mobile_number'.tr);
      return;
    }
         
    if (mobile.length != 10) {
      Get.snackbar('error'.tr, 'mobile_invalid_length'.tr);
      return;
    }
         
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      Get.snackbar('error'.tr, 'mobile_only_digits'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final endpoint = '/Login/get-otp?mobile=$mobile';
             
      final response = await ApiService.put(endpoint);

      if (response['status'] == 'Success') {
        // Extract email from response if available
        String email = 'your registered email';
        if (response['email'] != null && response['email'].isNotEmpty) {
          email = response['email'];
        } else if (response['result'] != null &&
                    response['result'].isNotEmpty &&
                    response['result'][0]['email'] != null) {
          email = response['result'][0]['email'];
        }
                 
        Get.snackbar('success'.tr, 'otp_sent_success'.tr);
                 
        // Navigate to Reset Password screen
        Get.to(() => ResetPasswordScreen(
          mobile: mobile,
          email: email,
        ));
      } else {
        Get.snackbar('error'.tr, response['message'] ?? 'failed_to_send_otp'.tr);
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
    super.onClose();
  }
}