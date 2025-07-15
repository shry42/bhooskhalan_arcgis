import 'package:flutter/material.dart';

Widget buildMovementSubSection({
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  );
}

