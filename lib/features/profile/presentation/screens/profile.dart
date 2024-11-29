import 'dart:io';
import 'package:flareup/core/constants/constants.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flareup/core/widgets/circle_vatar.dart';
import 'package:flareup/features/profile/presentation/widgets/name_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routs.dart';
import '../../../../core/utils/image_picker_service.dart';
import '../bloc/user_profile_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: AppTextStyles.primaryTextTheme(fontSize: 20),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final state = context.read<UserProfileBloc>().state;
              if (state is UserProfileLoaded) {
                final user = state.user;
                context.read<UserProfileBloc>().add(UpdateUserProfile(user));
              }
            },
            child: const Text('Done'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  Avatar(
                    radius: 30,
                    imgUrl: user.profileImage,
                  ),
                  minHeight,
                  TextButton(
                    onPressed: () async {
                      File? imageFile = await ImagePickerService.pickImageFromGallery();
                      if (imageFile != null) {
                        context.read<UserProfileBloc>().add(UploadProfileImage(imageFile));
                      }
                    },
                    child: const Text('Change Profile Photo')
                  ),
                  largeHeight,
                  NameListTile(
                    leading: 'UserName',
                    title: user.username,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouts.editProf,
                          arguments: {
                            'field': user.username,
                            'fieldType': 'UserName'
                          });
                    }),
                  minHeight,
                  NameListTile(
                    leading: 'FullName',
                    title: user.fullName,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouts.editProf,
                          arguments: {
                            'field': user.fullName,
                            'fieldType': 'FullName'
                          });
                    }),
                  minHeight,
                  Text(
                    'Private Information',
                    style: AppTextStyles.primaryTextTheme(),
                  ),
                  mediumHeight,
                  NameListTile(
                    leading: 'Email',
                    title: user.email,
                    onTap: () {
                      Navigator.pushNamed(context, AppRouts.editProf,
                          arguments: {
                            'field': user.email,
                            'fieldType': 'Email'
                          });
                    }),
                  minHeight,
                  NameListTile(
                    leading: 'Phone',
                    title: user.phoneNumber ?? 'Not set',
                    onTap: () {
                      Navigator.pushNamed(context, AppRouts.editProf,
                          arguments: {
                            'field': user.phoneNumber ?? '',
                            'fieldType': 'PhoneNumber'
                          });
                    }),
                  minHeight,
                  NameListTile(
                    leading: 'Role',
                    title: user.role,
                    onTap: () {},
                  ),
                ],
              );
            } else if (state is UserProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context, 
                        AppRouts.signIn
                      ),
                      child: const Text('Return to Login'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
