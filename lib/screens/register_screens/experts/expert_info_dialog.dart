
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showExpertInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
              text: 'expert_label'.tr,
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: 'expert_description'.tr,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ok'.tr, style: const TextStyle(color: Colors.blue)),
        ),
      ],
    ),
  );
}