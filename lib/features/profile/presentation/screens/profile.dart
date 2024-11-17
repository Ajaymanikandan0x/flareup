import 'dart:io';

import 'package:flareup/core/constants/constants.dart';
import 'package:flareup/core/theme/text_theme.dart';
import 'package:flareup/core/widgets/circle_vatar.dart';
import 'package:flareup/features/profile/presentation/widgets/name_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/user_profile_entity.dart';
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
              // Ensure you are in the context of the UserProfileLoaded state
              final state = context.read<UserProfileBloc>().state;
              if (state is UserProfileLoaded) {
                final user = state.user; // Access the user from the loaded state

                final updatedUserProfile = UserProfileEntity(
                  id: user.id,
                  username: user.username,
                  fullName: user.fullName,
                  email: user.email,
                  phoneNumber: user.phoneNumber,
                  gender: user.gender,
                  profileImage: user.profileImage,
                  role: user.role,
                );
                context.read<UserProfileBloc>().add(UpdateUserProfile( updatedUserProfile));
              }
            },
            child: const Text('Done'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(9),
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserProfileLoaded) {
              final user = state.user;
              return Column(
                children: [
                  Avatar(
                    imgUrl: user.profileImage,
                  ),
                  minHeight,
                  TextButton(
                      onPressed: ()async {
                         final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          File imageFile = File(pickedFile.path); // Convert to File
                        //server logic
                        }
                      },
                      child: const Text('Change Profile Photo')),
                  largeHeight,
                  NameListTile(
                      leading: 'Name', title: user.username, onTap: () {}),
                  minHeight,
                  NameListTile(
                      leading: 'FullName', title: user.fullName, onTap: () {}),
                  minHeight,
                  NameListTile(
                      leading: 'Name', title: user.username, onTap: () {}),
                  largeHeight,
                  Text(
                    'Private Information',
                    style: AppTextStyles.primaryTextTheme(),
                  ),
                  mediumHeight,
                  NameListTile(
                      leading: 'Email', title: user.email, onTap: () {}),
                  minHeight,
                  NameListTile(
                      leading: 'Phone',
                      title: user.phoneNumber ?? '',
                      onTap: () {}),
                  minHeight,
                  NameListTile(
                      leading: 'Gender',
                      title: user.gender ?? '',
                      onTap: () {}),
                ],
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}
