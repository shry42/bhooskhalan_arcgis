import 'package:bhooskhalann/translations/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLanguageSelectionDialog(BuildContext context) {
  final LanguageController languageController = Get.find<LanguageController>();
  
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
          maxHeight: 300, // Prevent overflow
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'select_language'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // English Button - Fixed Obx usage
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<LanguageController>(
                      builder: (controller) => ElevatedButton(
                        onPressed: () async {
                          await controller.changeToEnglish();
                          Navigator.pop(context);
                          
                          Get.snackbar(
                            'language_changed'.tr,
                            'language_changed_to_english'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isEnglish 
                              ? Colors.blue.shade700 
                              : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🇺🇸', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'english'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (controller.isEnglish) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check, color: Colors.white, size: 20),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Hindi Button - Fixed Obx usage
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<LanguageController>(
                      builder: (controller) => ElevatedButton(
                        onPressed: () async {
                          await controller.changeToHindi();
                          Navigator.pop(context);
                          
                          Get.snackbar(
                            'language_changed'.tr,
                            'language_changed_to_hindi'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            duration: const Duration(seconds: 2),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isHindi 
                              ? Colors.blue.shade700 
                              : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'hindi'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'NotoSansDevanagari',
                              ),
                            ),
                            if (controller.isHindi) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check, color: Colors.white, size: 20),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Close button (top-right)
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.black87,
                    child: Icon(
                      Icons.close, 
                      size: 16, 
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}