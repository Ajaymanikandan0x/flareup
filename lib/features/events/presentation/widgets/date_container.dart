import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';

class DateContainer extends StatelessWidget {
  final String date;
  const DateContainer({super.key, required this.date});

  String _formatDate(String dateStr) {
    try {
      final DateTime dateTime = DateTime.parse(dateStr);
      final months = [
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC'
      ];
      return '${months[dateTime.month - 1]}\n${dateTime.day}';
    } catch (e) {
      return dateStr; // Return original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final height = screenSize.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.01,
      ),
      constraints: BoxConstraints(
        minWidth: width * 0.1,
        maxWidth: width * 0.3,
        minHeight: height * 0.05,
        maxHeight: height * 0.08,
      ),
      decoration: BoxDecoration(
        gradient: AppPalette.primaryGradient,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(
        _formatDate(date),
        style: AppTextStyles.primaryTextTheme(),
        textAlign: TextAlign.center,
      ),
    );
  }
}
