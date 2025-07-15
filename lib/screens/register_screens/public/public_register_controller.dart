import 'package:bhooskhalann/screens/register_screens/otp_screens/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicRegisterController extends GetxController {
  // Controllers for form fields
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Observable variables for UI state
  RxBool isLoading = false.obs;
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }
  
  // Comprehensive input validation
  String? validateInputs() {
    // Username validation
    final username = usernameController.text.trim();
    if (username.isEmpty) {
      return 'username_required'.tr;
    }
    if (username.length < 3) {
      return 'username_min_length'.tr;
    }
    if (username.length > 30) {
      return 'username_max_length'.tr;
    }
    
    // Email validation
    final email = emailController.text.trim();
    if (email.isEmpty) {
      return 'email_required'.tr;
    }
    if (!GetUtils.isEmail(email)) {
      return 'email_invalid'.tr;
    }
    
    // Mobile validation
    final mobile = mobileController.text.trim();
    if (mobile.isEmpty) {
      return 'mobile_required'.tr;
    }
    if (mobile.length != 10) {
      return 'mobile_invalid_length'.tr;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(mobile)) {
      return 'mobile_only_digits'.tr;
    }
    
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
    
    return null; // No validation errors
  }
  
  // Register user method
  Future<void> registerUser() async {
    // First validate inputs
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
    
    // Show loading state
    isLoading.value = true;
    
    try {
      // Get input values
      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final mobile = mobileController.text.trim();
      final password = passwordController.text;
      
      // Create exact URL string as shown in your example
      const baseUrl = 'https://bhusanket.gsi.gov.in/webapi';
      
      // Manually create the query string to match exactly what works
      final urlString = '$baseUrl/Register/create?mobile=$mobile&email=$email&username=$username'
          '&password=$password&usertype=Public&Organization=&tocken=&datetim=&session=&otp=&status=&otp_session=';
      
      // Log the request URL for debugging
      print("Request URL: $urlString");
      
      // Parse the URL
      final url = Uri.parse(urlString);
      
      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Referer': 'https://bhusanket.gsi.gov.in/',
        },
      );
      
      // Log the response for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      
      // Handle the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData != null && responseData['status'] == "Success") {
          // Registration successful - Store user data in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);
          await prefs.setString('email', email);
          await prefs.setString('mobile', mobile);
          await prefs.setString('usertype', 'Public');
          
          // Show success message
          Get.snackbar(
            'success'.tr, 
            'registration_successful_verify'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
          );
          
          // Navigate based on OTP presence in response
          if (responseData['result'] != null && 
              responseData['result'].isNotEmpty && 
              responseData['result'][0]['otp'] != null) {
            // If OTP is generated, go to verification screen
            Get.off(() => OTPVerificationScreen(
              mobile: mobile,
              email: email,
            ));
            
          } else {
            // If no OTP in response, still go to OTP verification
            // (assuming OTP was sent via email)
            Get.off(() => OTPVerificationScreen(
              mobile: mobile,
              email: email,
            ));
          }
        } else {
          // Registration failed
          Get.snackbar(
            'registration_failed'.tr, 
            responseData?['statusMessage'] ?? 'unknown_error_occurred'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        // HTTP request failed
        Get.snackbar(
          'error'.tr, 
          '${'server_error'.tr}: ${response.statusCode}. ${'try_again_later'.tr}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Exception handling
      print("Exception during registration: $e");
      Get.snackbar(
        'error'.tr, 
        '${'something_went_wrong'.tr}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      // Always hide loading state
      isLoading.value = false;
    }
  }
  
  // Reset form fields
  void resetForm() {
    usernameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
  
  // Dispose resources when controller is closed
  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}