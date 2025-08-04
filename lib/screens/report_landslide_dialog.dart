import 'package:bhooskhalann/landslide/report_landslide_maps_screen/maps/arcgis_map_screen.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/maps/google_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSafetyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const SafetyDialog(),
  );
}

class SafetyDialog extends StatefulWidget {
  const SafetyDialog({super.key});

  @override
  State<SafetyDialog> createState() => _SafetyDialogState();
}

class _SafetyDialogState extends State<SafetyDialog> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.only(left: 16,right: 16,bottom: 60,top: 90),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Close Icon
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            Text(
              'safety_measures_title'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafetyBullet(text: 'safety_measure_1'.tr),
                    SafetyBullet(text: 'safety_measure_2'.tr),
                    SafetyBullet(text: 'safety_measure_3'.tr),
                    SafetyBullet(text: 'safety_measure_4'.tr),
                    SafetyBullet(text: 'safety_measure_5'.tr),
                    SafetyBullet(text: 'safety_measure_6'.tr),
                    SafetyBullet(text: 'safety_measure_7'.tr),
                    SafetyBullet(text: 'safety_measure_8'.tr),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Checkbox and text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() => isChecked = value ?? false);
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'safety_agreement_text'.tr,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // AGREE button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isChecked
                    ? () {
                        Navigator.of(context).pop();
                        // Add your confirmation logic here
                        // Get.to(ArcGisMapScreen());
                        // Get.to(GoogleMapScreen());
                        Get.to(ArcGisLocationMapScreen());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isChecked ? Colors.blue : Colors.grey.shade400,
                ),
                child: Text(
                  'agree_button'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}

class SafetyBullet extends StatelessWidget {
  final String text;
  const SafetyBullet({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}