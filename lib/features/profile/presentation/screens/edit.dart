import 'package:flareup/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validation.dart';
import '../../../../core/widgets/custome_text.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/form_feild.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String field;
  late String fieldType;
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, String?> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, String?>;

    field = arguments['field'] ?? '';
    fieldType = arguments['fieldType'] ?? '';

    controller.text = field;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  data: fieldType,
                  fontsSize: 30,
                ),
              ),
              largeHeight,
              AppFormField(
                hint: '',
                isObscureText: false,
                controller: controller,
                validator: (value) {
                  return _validateInput(value, fieldType);
                },
              ),
              const Spacer(),
              BlocConsumer<UserProfileBloc, UserProfileState>(
                listener: (context, state) {
                  if (state is UserProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is UserProfileLoaded) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<UserProfileBloc>().add(
                          UpdateProfileField(
                            fieldType: fieldType,
                            newValue: controller.text.trim(),
                          ),
                        );
                      }
                    },
                    text: state is UserProfileLoading ? 'Saving...' : 'Save',
                    width: 300,
                    height: 55,
                  );
                },
              ),
              largeHeight,
            ],
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value, String fieldType) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    switch (fieldType) {
      case 'Email':
        return FormValidator.validateEmail(value);
      case 'Phone':
        return FormValidator.validatePhone(value);
      case 'UserName':
        return FormValidator.validateUserName(value);
      case 'FullName':
        return FormValidator.validateName(value);
      default:
        return null;
    }
  }
}
