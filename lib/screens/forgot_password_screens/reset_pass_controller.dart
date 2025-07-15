import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final String mobile;
  
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();
  
  RxBool isLoading = false.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  ResetPasswordController({required this.mobile});

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  String? validateInputs() {
    // Password validation
    final password = passwordController.text;
    if (password.isEmpty) {
      return 'password_required'.tr;
    }
    if (password.length < 6) {
      return 'password_min_length'.tr;
    }
    
    // Check for password strength
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int strengthPoints = 0;
    if (hasUppercase) strengthPoints++;
    if (hasLowercase) strengthPoints++;
    if (hasDigit) strengthPoints++;
    if (hasSpecialChar) strengthPoints++;
    
    if (strengthPoints < 3) {
      return 'password_strength_required'.tr;
    }
    
    // Confirm password validation
    final confirmPassword = confirmPasswordController.text;
    if (confirmPassword.isEmpty) {
      return 'confirm_password_required'.tr;
    }
    if (password != confirmPassword) {
      return 'passwords_do_not_match'.tr;
    }

    // OTP validation
    final otp = otpController.text.trim();
    if (otp.isEmpty) {
      return 'otp_required'.tr;
    }
    if (otp.length < 4) {
      return 'otp_invalid'.tr;
    }
    
    return null; // No validation errors
  }

  void resetPassword() async {
    // Validate inputs
    final validationError = validateInputs();
    if (validationError != null) {
      Get.snackbar(
        'error'.tr, 
        validationError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      final password = passwordController.text;
      final otp = otpController.text.trim();
      
      final endpoint = '/Register/update?mobile=$mobile&password=$password&otp=$otp';
      
      final response = await ApiService.put(endpoint);

      if (response['status'] == 'Success') {
        Get.snackbar(
          'success'.tr, 
          'password_reset_successful'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        
        // Navigate back to login screen (go back twice to skip forgot password screen)
       Get.to(LoginRegisterScreen());
      } else {
        Get.snackbar(
          'reset_failed'.tr, 
          response['message'] ?? 'failed_to_reset_password'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr, 
        '${'something_went_wrong'.tr}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}