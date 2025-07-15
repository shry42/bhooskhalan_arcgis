import 'package:bhooskhalann/screens/expert_login_screens/expert_login_controller.dart';
import 'package:bhooskhalann/screens/forgot_password_screens/forgot_password_screen.dart';
import 'package:bhooskhalann/screens/register_screens/experts/register_form_expert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpertLoginScreen extends StatelessWidget {
  const ExpertLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ExpertLoginController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/logo.png', height: 120, width: 350),
            const SizedBox(height: 10),
            _buildLogoText(),
            const SizedBox(height: 30),
            Text(
              'login_as_expert'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 30),

            // Mobile Number Field
            TextField(
              controller: controller.mobileController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('mobile_number'.tr),
            ),
            const SizedBox(height: 16),

            // Password Field
            Obx(() => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: _inputDecoration('password'.tr).copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                  ),
                )),
            const SizedBox(height: 12),

            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: controller.isRememberMe.value,
                          onChanged: controller.toggleRememberMe,
                        ),
                        Text('remember_me'.tr),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(ForgotPasswordScreen());
                      },
                      child: Text(
                        'forgot_password'.tr,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                )),

            const SizedBox(height: 10),

            // Login Button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : controller.login,
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
                        : Text(
                            'login'.tr.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                )),

            const SizedBox(height: 320),

            // Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('dont_have_account'.tr + ' '),
                GestureDetector(
                  onTap: () {
                    Get.to(RegisterFormExpert());
                  },
                  child: Text(
                    'register_now'.tr,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Logo Title with Styled Letters & Images
  Widget _buildLogoText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _boldChar("B"),
        _boldChar("H"),
        _circleImage('assets/india_map.png'),
        _circleImage('assets/globe_asia.png'),
        _boldChar("S"),
        _boldChar("K"),
        _boldChar("H"),
        _dotText("A"),
        _landslideText("L"),
        _landslideText("A"),
        _boldChar("N"),
      ],
    );
  }

  /// Styled Input
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  /// Bold Single Character
  Widget _boldChar(String char) {
    return Text(
      char,
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Circular Image in Logo
  Widget _circleImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Character with Dot (e.g., A.)
  Widget _dotText(String char) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _boldChar(char),
        const Positioned(
          right: 0,
          child: Text(
            ".",
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      ],
    );
  }

  /// Landslide Text Style
  Widget _landslideText(String char) {
    return Text(
      char,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.brown),
        ],
      ),
    );
  }
}