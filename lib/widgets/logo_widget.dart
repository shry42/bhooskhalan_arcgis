  import 'dart:ui';

import 'package:flutter/material.dart';

Widget _boldChar(String char) {
    return Text(
      char,
      style: const TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    );
  }

Widget _circleImage(String assetPath) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1), // thin black border
        image: DecorationImage(
          image: AssetImage(assetPath),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}


  Widget _dotText(String char) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        _boldChar(char),
        const Positioned(
          right: 0,
          child: Text(
            ".",
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _landslideText(String char) {
    return Text(
      char,
      style: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.brown),
        ],
      ),
    );
  }
