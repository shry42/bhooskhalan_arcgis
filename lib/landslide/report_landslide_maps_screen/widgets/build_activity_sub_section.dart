import 'package:flutter/material.dart';

Widget buildActivitySubSection({
  required String letter,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          height: 1.4,
        ),
        children: [
          TextSpan(
            text: letter,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '$title-',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: description,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
