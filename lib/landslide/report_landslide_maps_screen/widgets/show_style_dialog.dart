import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_style_section.dart';
import 'package:flutter/material.dart';

void showStyleDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Style',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildStyleSection(
                        title: 'Complex',
                        description: 'A complex landslide exhibits at least two types of movement (falling, toppling, sliding, spreading and flowing) in sequence.',
                      ),
                      
                      buildStyleSection(
                        title: 'Composite',
                        description: 'A composite landslide exhibits at least two types of movement simultaneously in different parts of the displacing mass.',
                      ),
                      
                      buildStyleSection(
                        title: 'Successive',
                        description: 'A successive landslide is the same type as a nearby, earlier landslide, but does not share displaced material or rupture surface with it.',
                      ),
                      
                      buildStyleSection(
                        title: 'Multiple',
                        description: 'A multiple landslide shows repeated development of the same type of movement.',
                      ),
                      
                      buildStyleSection(
                        title: 'Single',
                        description: 'A single landslide is a single movement of displaced material.',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
