import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/routes/routs.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../../core/theme/text_theme.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/widgets/circle_vatar.dart';
import '../../../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../features/authentication/presentation/bloc/auth_event.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';
import 'drawer_list_tile.dart';

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
    // Initialize responsive utilities
    Responsive.init(context);

    // Calculate responsive dimensions
    final headerPaddingTop = Responsive.screenHeight * 0.07;
    final headerPaddingHorizontal = Responsive.horizontalPadding;
    final headerPaddingBottom = Responsive.verticalPadding;
    final avatarRadius = Responsive.isTablet ? 65.0 : 55.0;
    final nameTextSize = Responsive.isTablet ? 24.0 : 22.0;
    final menuItemTextSize = Responsive.isTablet ? 18.0 : 16.0;
    final iconSize = Responsive.isTablet ? 24.0 : 22.0;
    final dividerHeight = Responsive.isTablet ? 40.0 : 32.0;

    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppPalette.darkCard
          : AppPalette.lightCard,
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (state is UserProfileLoaded) ...[
                Container(
                  padding: EdgeInsets.fromLTRB(
                    headerPaddingHorizontal,
                    headerPaddingTop,
                    headerPaddingHorizontal,
                    headerPaddingBottom,
                  ),
                  decoration: const BoxDecoration(
                    gradient: AppPalette.primaryGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Avatar(
                        radius: avatarRadius,
                        imgUrl: state.user.profileImage,
                      ),
                      SizedBox(height: Responsive.spacingHeight),
                      Text(
                        state.user.fullName,
                        style: AppTextStyles.primaryTextTheme(
                          fontSize: nameTextSize,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: Responsive.spacingHeight),
              // Rest of the drawer items with responsive dimensions
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding,
                ),
                child: DrawerListTile(
                  icon: FontAwesomeIcons.userPen,
                  title: 'Edit Profile',
                  onTap: () => Navigator.pushNamed(context, AppRouts.profile),
                ),
              ),
              // Theme Toggle
              BlocBuilder<ThemeCubit, bool>(
                builder: (context, isDark) {
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Responsive.horizontalPadding * 1.5,
                    ),
                    leading: Icon(
                      isDark ? Icons.dark_mode : Icons.light_mode,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppPalette.darkText
                          : AppPalette.lightText,
                      size: iconSize,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: AppTextStyles.primaryTextTheme(
                        fontSize: menuItemTextSize,
                      ),
                    ),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                      activeColor: AppPalette.gradient2,
                      activeTrackColor: AppPalette.gradient2.withOpacity(0.5),
                    ),
                  );
                },
              ),
              // Rest of menu items
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.horizontalPadding,
                ),
                child: Column(
                  children: [
                    DrawerListTile(
                      icon: FontAwesomeIcons.bell,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.star,
                      title: 'Rate App',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.share,
                      title: 'Share App',
                      onTap: () {},
                    ),
                    Divider(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppPalette.darkText.withOpacity(0.2)
                          : AppPalette.lightText.withOpacity(0.2),
                      height: dividerHeight,
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.shield,
                      title: 'Privacy Policy',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.file,
                      title: 'Terms and Conditions',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.cookie,
                      title: 'Cookies Policy',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.envelope,
                      title: 'Contact',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.message,
                      title: 'Feedback',
                      onTap: () {},
                    ),
                    DrawerListTile(
                      icon: FontAwesomeIcons.rightFromBracket,
                      title: 'Logout',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Logout',
                              style: AppTextStyles.primaryTextTheme(
                                fontSize: Responsive.subtitleFontSize,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to logout?',
                              style: AppTextStyles.primaryTextTheme(
                                fontSize: Responsive.bodyFontSize,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.primaryTextTheme(
                                    fontSize: Responsive.bodyFontSize,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(LogoutEvent());
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    AppRouts.signIn,
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  'Logout',
                                  style: AppTextStyles.primaryTextTheme(
                                    fontSize: Responsive.bodyFontSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
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
