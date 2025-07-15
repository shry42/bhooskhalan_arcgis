import 'package:bhooskhalann/screens/public_login_screens/public_login_screen.dart';
import 'package:bhooskhalann/screens/register_screens/public/public_info_dialog.dart';
import 'package:bhooskhalann/screens/register_screens/public/public_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Import the controller

class RegisterFormPublic extends StatefulWidget {
  const RegisterFormPublic({super.key});

  @override
  State<RegisterFormPublic> createState() => _RegisterFormPublicState();
}

class _RegisterFormPublicState extends State<RegisterFormPublic> {
  // Initialize the controller
  final PublicRegisterController controller = Get.put(PublicRegisterController());

  final _inputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
  );

  @override
  void initState() {
    super.initState();
    // Delay so the dialog doesn't show before build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showPublicInfoDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80),
                
                Image.asset('assets/logo.png', height: 120, width: 350),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'register_as_public'.tr,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 32),
                
                      // Username
                      TextField(
                        controller: controller.usernameController,
                        decoration: _inputDecoration.copyWith(hintText: 'username'.tr),
                      ),
                      const SizedBox(height: 16),
                
                      // Email
                      TextField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration.copyWith(hintText: 'email_id'.tr),
                      ),
                      const SizedBox(height: 16),
                
                      // Mobile
                      TextField(
                        controller: controller.mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: _inputDecoration.copyWith(hintText: 'mobile_number'.tr),
                      ),
                      const SizedBox(height: 16),
                
                      // Password
                      Obx(() => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        decoration: _inputDecoration.copyWith(
                          hintText: 'password'.tr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscurePassword.value 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),
                
                      // Confirm Password
                      Obx(() => TextField(
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        decoration: _inputDecoration.copyWith(
                          hintText: 'confirm_password'.tr,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obscureConfirmPassword.value 
                                  ? Icons.visibility 
                                  : Icons.visibility_off,
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        ),
                      )),
                      const SizedBox(height: 24),
                
                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value 
                              ? null 
                              : controller.registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'register'.tr.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                
                      const SizedBox(height: 16),
                
                      // Login redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('already_have_account'.tr + ' '),
                          GestureDetector(
                            onTap: () {
                              // Navigate to login
                              Get.to(() => PublicLoginScreen());
                            },
                            child: Text(
                              'login'.tr,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Loading overlay
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      )),
    );
  }

  // Your existing widget methods...
  Widget _boldChar(String char) {
    return Text(
      char,
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _circleImage(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1), // thin black border
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

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