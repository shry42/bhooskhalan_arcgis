import 'dart:async';
import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPVerificationController extends GetxController {
  final String mobile;
  
  // OTP Controllers for 4 digits
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;
  
  RxBool isLoading = false.obs;
  RxBool canResendOTP = false.obs;
  RxInt resendTimer = 30.obs;
  
  Timer? _timer;

  OTPVerificationController({required this.mobile});

  @override
  void onInit() {
    super.onInit();
    
    // Initialize OTP controllers and focus nodes
    otpControllers = List.generate(4, (index) => TextEditingController());
    focusNodes = List.generate(4, (index) => FocusNode());
    
    // Start resend timer
    startResendTimer();
  }

  void onOTPChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Move to next field if not the last one
      if (index < 3) {
        focusNodes[index + 1].requestFocus();
      } else {
        // Last field, remove focus
        focusNodes[index].unfocus();
      }
    } else {
      // Move to previous field if not the first one
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  String getOTP() {
    return otpControllers.map((controller) => controller.text.trim()).join();
  }

  void startResendTimer() {
    canResendOTP.value = false;
    resendTimer.value = 30;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResendOTP.value = true;
        timer.cancel();
      }
    });
  }

  void verifyOTP() async {
    final otp = getOTP();
    
    if (otp.length != 4) {
      Get.snackbar("Error", "Please enter complete 4-digit OTP");
      return;
    }

    isLoading.value = true;

    try {
      final endpoint = '/Login/verify-otp?mobile=$mobile&otp=$otp';
      
      final response = await ApiService.get(endpoint);

      if (response['status'] == 'Success') {
        // Store additional verification data if needed
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isOTPVerified', true);
        
        Get.snackbar("Success", "OTP verified successfully");
        
        // Navigate to HomeScreen
        Get.off(() =>  LoginRegisterScreen());
      } else {
        Get.snackbar("Verification Failed", response['message'] ?? 'Invalid OTP');
        // Clear OTP fields on failure
        clearOTPFields();
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      clearOTPFields();
    } finally {
      isLoading.value = false;
    }
  }

  void resendOTP() async {
    try {
      // You might need to implement a resend OTP endpoint
      // For now, just restart the timer
      Get.snackbar("Info", "OTP resent successfully");
      clearOTPFields();
      startResendTimer();
      
      // If you have a specific resend endpoint, implement it here:
      // final endpoint = '/Login/resend-otp?mobile=$mobile';
      // final response = await ApiService.get(endpoint);
      
    } catch (e) {
      Get.snackbar("Error", "Failed to resend OTP: $e");
    }
  }

  void clearOTPFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    // Focus on first field
    if (focusNodes.isNotEmpty) {
      focusNodes[0].requestFocus();
    }
  }

  @override
  void onClose() {
    // Dispose controllers and focus nodes
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    
    // Cancel timer
    _timer?.cancel();
    
    super.onClose();
  }
}