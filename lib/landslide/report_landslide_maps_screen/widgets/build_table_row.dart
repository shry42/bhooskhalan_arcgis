import 'package:flutter/material.dart';

Widget buildTableRow({
  required String category,
  required String description,
  required String stage,
  required bool isLast,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: isLast 
          ? BorderSide.none 
          : BorderSide(color: Colors.grey[300]!),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                height: 1.3,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              stage,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    ),
  );
}
