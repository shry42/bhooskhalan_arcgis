import 'package:bhooskhalann/screens/forgot_password_screens/reset_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String mobile;
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.mobile,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController(mobile: mobile));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            
            // Instructions with masked email
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Enter the new password and OTP sent to your Email: '),
                  TextSpan(
                    text: _maskEmail(email),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // Password Field
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
            
            const SizedBox(height: 16),

            // Confirm Password Field
            Obx(() => TextField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  decoration: InputDecoration(
                    hintText: 'Confirm password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            // OTP Field
            TextField(
              controller: controller.otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter the OTP',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              ),
            ),

            const SizedBox(height: 40),

            // Reset Password Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'RESET PASSWORD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // Helper function to mask email
  String _maskEmail(String email) {
    if (email.contains('@')) {
      final parts = email.split('@');
      final username = parts[0];
      final domain = parts[1];
      
      if (username.length <= 2) {
        return email; // Don't mask very short usernames
      }
      
      final firstChar = username[0];
      final lastChar = username[username.length - 1];
      final maskedMiddle = '*' * (username.length - 2);
      
      return '$firstChar$maskedMiddle$lastChar@$domain';
    }
    return email;
  }
}