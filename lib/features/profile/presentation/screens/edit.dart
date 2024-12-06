import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/utils/validation.dart';
import '../../../../core/widgets/custome_text.dart';
import '../../../../core/widgets/form_feild.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../profile/presentation/bloc/user_profile_bloc.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

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
    Responsive.init(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.horizontalPadding,
          vertical: Responsive.verticalPadding,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  data: fieldType,
                  fontsSize: Responsive.titleFontSize,
                ),
              ),
              SizedBox(height: Responsive.spacingHeight),
              AppFormField(
                hint: '',
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
                    width: Responsive.screenWidth * 0.85,
                    height: Responsive.buttonHeight,
                  );
                },
              ),
              SizedBox(height: Responsive.spacingHeight),
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
