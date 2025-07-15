import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_register_controller.dart';

class LoginRegisterScreen extends StatelessWidget {
  final LoginRegisterController controller = Get.put(LoginRegisterController());

  LoginRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => controller.showLanguageDialog(context),
                    child: Image.asset('assets/translator.png', height: 60),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              Image.asset('assets/logo.png', height: 150, width: 400),
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
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.showLoginDialog(context),
                        // onPressed: ()=> Get.to(ArcGisMapScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'login'.tr.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: controller.goToRegisterForm,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'register'.tr.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: controller.registerAsExpert,
                      child: Text(
                        'register_as_expert'.tr,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('assets/landslide_img.png', height: 550),
            ],
          ),
        ),
      ),
    );
  }

  Widget _boldChar(String char) {
    return Text(
      char,
      style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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
          border: Border.all(color: Colors.black, width: 1),
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