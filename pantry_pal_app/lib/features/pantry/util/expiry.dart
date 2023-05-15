import 'package:flutter/material.dart';
import 'package:pantry_pal/features/api/api_http.dart';
import "../../../shared/date_extension.dart";

Text getExpiryText(PantryItem item) {
  final text = "exp ${item.expiryDate.toDisplay()}";
  final now = DateTime.now();

  Color? color;

  if (item.expiryDate.isBefore(now)) {
    color = Colors.red;
  } else if (item.expiryDate.subtract(const Duration(days: 3)).isBefore(now)) {
    color = Colors.deepOrange;
  }

  return Text(text, style: color != null ? TextStyle(color: color) : null);
}