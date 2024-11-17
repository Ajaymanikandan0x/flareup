import 'package:flareup/core/constants/constants.dart';
import 'package:flareup/core/widgets/custome_text.dart';
import 'package:flareup/core/widgets/primary_button.dart';
import 'package:flareup/features/authentication/presentation/widgets/auth/form_feild.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String field;
  final String fieldType;
  EditProfile({super.key, required this.field, required this.fieldType});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.field;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(9),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppText(data: widget.fieldType),
              largeHeight,
              AppFormField(
                hint: '',
                isObscureText: false,
                controller: controller,
                validator: (value) {
                  return _validateInput(value, widget.fieldType);
                },
              ),
              PrimaryButton(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, controller.text);
                  }
                },
                text: 'Save',
                width: 250,
                height: 40,
              )
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
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        break;
      case 'Phone':
        if (!RegExp(r'^\+?[0-9]{1,15}$').hasMatch(value)) {
          return 'Please enter a valid phone number';
        }
        break;
      case 'Name':
      case 'Username':
        if (value.length < 3) {
          return 'Must be at least 3 characters long';
        }
        break;
      default:
        break;
    }
    return null;
  }
}
