import 'package:flutter/material.dart';

/// Parses a time string in "HH:mm" format into a [DateTime] object with today's date.
DateTime? parseTime(String? time) {
  if (time == null || time.isEmpty) return null;
  try {
    final parts = time.split(':');
    if (parts.length == 2) {
      return DateTime(0, 0, 0, int.parse(parts[0]), int.parse(parts[1]));
    }
  } catch (e) {
    debugPrint('Error parsing time: $e');
  }
  return null;
}

/// Returns the open status of a restaurant based on its opening and closing times,
/// along with the color to display for the status.
Map<String, dynamic> getOpenStatus(String? openingTime, String? closingTime) {
  final now = DateTime.now();
  final openingDateTime = parseTime(openingTime);
  final closingDateTime = parseTime(closingTime);

  if (openingDateTime != null && closingDateTime != null) {
    final todayOpeningTime = DateTime(now.year, now.month, now.day,
        openingDateTime.hour, openingDateTime.minute);
    final todayClosingTime = DateTime(now.year, now.month, now.day,
        closingDateTime.hour, closingDateTime.minute);

    if (now.isAfter(todayOpeningTime) && now.isBefore(todayClosingTime)) {
      return {'status': 'Đang mở cửa', 'color': Colors.green};
    } else {
      return {'status': 'Đóng cửa', 'color': Colors.red};
    }
  }
  return {'status': 'Thông tin không đầy đủ', 'color': Colors.grey};
}
