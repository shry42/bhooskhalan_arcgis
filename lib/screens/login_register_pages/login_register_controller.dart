
import 'package:bhooskhalann/screens/language_dialog.dart';
import 'package:bhooskhalann/screens/login_as_public_expert_dialog_box.dart';
import 'package:bhooskhalann/screens/register_screens/experts/register_form_expert.dart';
import 'package:bhooskhalann/screens/register_screens/public/register_form_public.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginRegisterController extends GetxController {
  void showLanguageDialog(BuildContext context) {
    // Call your language dialog
    showLanguageSelectionDialog(context);
  }

  void showLoginDialog(BuildContext context) {
    showLoginAsPublicAndExpertDialog(context);
  }

  void goToRegisterForm() {
    Get.to(RegisterFormPublic()); // Use named route or direct widget
  }

  void registerAsExpert() {
    Get.to(RegisterFormExpert());
  }
}
