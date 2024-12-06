import 'package:flareup/core/theme/app_palette.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flareup/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class NameListTile extends StatelessWidget {
  final String title;
  final String leading;
  final VoidCallback onTap;

  const NameListTile({
    super.key,
    required this.leading,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final double verticalPadding = Responsive.verticalPadding * 0.5;
    final double horizontalPadding = Responsive.horizontalPadding * 0.6;
    final double borderRadius = Responsive.borderRadius * 0.5;
    final double leadingFontSize = Responsive.subtitleFontSize;
    final double titleFontSize = Responsive.bodyFontSize;
    final double iconSize = Responsive.isTablet ? 28.0 : 24.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalPadding * 0.5),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark 
            ? AppPalette.darkCard 
            : AppPalette.lightCard,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        title: Text(
          title,
          style: AppTextStyles.primaryTextTheme(
            fontSize: titleFontSize,
          ),
        ),
        leading: Text(
          leading,
          style: AppTextStyles.primaryTextTheme(
            fontSize: leadingFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: iconSize,
          color: Theme.of(context).brightness == Brightness.dark 
              ? AppPalette.darkText.withOpacity(0.8)
              : AppPalette.lightText.withOpacity(0.8),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}