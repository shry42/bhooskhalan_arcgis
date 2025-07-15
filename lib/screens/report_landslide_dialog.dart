
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

            const Text(
              "Safety Measures",
              style: TextStyle(
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
                  children: const [
                    SafetyBullet(text: "Stay away from the main landslide areas. There may be danger of additional slides. Do not go near unstable buildings and structures."),
                    SafetyBullet(text: "Listen for any unusual sounds such as boulders knocking together. This may indicate moving debris. Stay away from such places."),
                    SafetyBullet(text: "Listen to the latest local radio or television news."),
                    SafetyBullet(text: "Watch out for WhatsApp and other messages for the latest emergency information."),
                    SafetyBullet(text: "Watch out for flooding which may occur after landslides. Keep away from streams and rivers."),
                    SafetyBullet(text: "Please note that rescuers have priority of access to landslide sites."),
                    SafetyBullet(text: "Always keep in mind your own safety and safety of others in landslide areas."),
                    SafetyBullet(text: "If you notice something unusual in the landslide area, please notify local emergency authorities."),
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
                      "I have read the safety measures and understood them. I will follow its instructions.",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
SizedBox(height: 20),
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
                child: const Text("AGREE",style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(height: 20,)
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
