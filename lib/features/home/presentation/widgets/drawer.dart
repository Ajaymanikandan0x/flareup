import 'package:flareup/core/routes/routs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/widgets/circle_vatar.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../features/authentication/presentation/bloc/auth_event.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';

class AppDrawerWrapper extends StatefulWidget {
  const AppDrawerWrapper({super.key});

  @override
  State<AppDrawerWrapper> createState() => _AppDrawerWrapperState();
}

class _AppDrawerWrapperState extends State<AppDrawerWrapper> {
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userId = await context.read<SecureStorageService>().getUserId();
    if (userId != null) {
      if (mounted) {
        context.read<UserProfileBloc>().add(LoadUserProfile(userId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AppDrawer();
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppPalette.cardColor,
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 260,
                child: DrawerHeader(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                  decoration: BoxDecoration(
                    color: AppPalette.cardColor.withOpacity(0.5),
                    border: Border(
                      bottom: BorderSide(
                        color: AppPalette.formIconColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state is UserProfileLoaded) ...[
                        Avatar(
                          imgUrl: state.user.profileImage,
                          radius: 57,
                          iconSize: 50,
                        ),
                        minHeight,
                        Text(
                          state.user.username,
                          style: AppTextStyles.primaryTextTheme(fontSize: 25),
                        )
                      ] else ...[
                        const Avatar(
                          imgUrl: null,
                          radius: 57,
                          iconSize: 50,
                        ),
                        minHeight,
                        Text(
                          'Loading...',
                          style: AppTextStyles.primaryTextTheme(fontSize: 25),
                        )
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
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
                      title: Text(
                        'Invite a friend',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.ticket,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Tickets',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.bookmark,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Bookmark',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.email,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Contact Us',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Settings',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.circleQuestion,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Helps & FAQs',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.arrowRightFromBracket,
                        color: AppPalette.formIconColor,
                      ),
                      title: Text(
                        'Sign Out',
                        style: AppTextStyles.primaryTextTheme(fontSize: 18),
                      ),
                      onTap: () async {
                        try {
                          context.read<AuthBloc>().add(LogoutEvent());
                          await Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRouts.signIn,
                            (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Logout failed: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
