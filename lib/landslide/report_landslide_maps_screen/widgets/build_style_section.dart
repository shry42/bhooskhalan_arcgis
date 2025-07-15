import 'package:flutter/material.dart';

Widget buildStyleSection({
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          height: 1.4,
        ),
        children: [
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
