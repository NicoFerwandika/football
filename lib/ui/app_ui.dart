import 'package:flutter/material.dart';

class AppUI {
  static const double radius = 18;

  static BoxDecoration cardBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static Widget iconBox(IconData icon) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon),
    );
  }

  static Widget pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF1FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}
