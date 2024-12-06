import 'package:flareup/core/theme/app_palette.dart';
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
    return ListTile(
      title: Text(title),
      leading: Text(leading),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      tileColor: Theme.of(context).brightness == Brightness.dark 
                ? AppPalette.darkCard 
                : AppPalette.lightCard,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8),
      // ),
    );
  }
}
