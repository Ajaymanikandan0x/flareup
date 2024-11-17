import 'package:flareup/core/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/circle_vatar.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPalette.cardColor,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 220,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Avatar(
                    imgUrl: null,
                    radius: 57,
                    iconSize: 50,
                  ),
                  minHeight,
                  Text(
                    'userName',
                    style: AppTextStyles.primaryTextTheme(fontSize: 25),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.user,
              color: AppPalette.formIconColor,
            ),
            title: Text(
              'Profile',
              style: AppTextStyles.primaryTextTheme(fontSize: 18),
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRouts.profile);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.userPlus,
              color: AppPalette.formIconColor,
            ),
            title: const Text('invite a friend'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.ticket,
              color: AppPalette.formIconColor,
            ),
            title: const Text('Tickets'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.bookmark,
              color: AppPalette.formIconColor,
            ),
            title: const Text('bookmark'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.email,
              color: AppPalette.formIconColor,
            ),
            title: const Text('contact Us'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: AppPalette.formIconColor,
            ),
            title: const Text('settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.circleQuestion,
              color: AppPalette.formIconColor,
            ),
            title: const Text('Helps & FAQs'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const FaIcon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: AppPalette.formIconColor,
            ),
            title: const Text('Sign Out'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
