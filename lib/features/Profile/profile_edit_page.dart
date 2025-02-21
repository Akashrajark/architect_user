import 'dart:io';

import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/common_widgets.dart/custom_image_picker_button.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:dream_home_user/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets.dart/custom_text_formfield.dart';
import 'profile_bloc/profile_bloc.dart';

class ProfileEditPage extends StatefulWidget {
  final Map profileDetails;
  const ProfileEditPage({super.key, required this.profileDetails});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
    _nameController.text = widget.profileDetails['name'];
    _phoneController.text = widget.profileDetails['phone'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            backgroundColor: secondaryColor,
            appBar: AppBar(
              backgroundColor: secondaryColor,
              title: const Text(
                'EDIT PROFILE',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 18),
              ),
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Picker
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomImagePickerButton(
                            selectedImage: widget.profileDetails['photo'],
                            height: 150,
                            width: 150,
                            borderRadius: 100,
                            onPick: (pick) {
                              file = pick;
                              setState(() {});
                            },
                          ),
                          if (file != null)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    file = null;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Name Field
                    Text(
                      'Name',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      isLoading: state is ProfileLoadingState,
                      controller: _nameController,
                      validator: alphabeticWithSpaceValidator,
                      labelText: 'Enter your name',
                    ),
                    const SizedBox(height: 20),

                    // Phone Field
                    Text(
                      'Phone Number',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      isLoading: state is ProfileLoadingState,
                      controller: _phoneController,
                      validator: phoneNumberValidator,
                      labelText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 40),

                    CustomButton(
                      inverse: true,
                      isLoading: state is ProfileLoadingState,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> details = {
                            'name': _nameController.text.trim(),
                            'phone': _phoneController.text.trim(),
                          };

                          if (file != null) {
                            details['photo_file'] = file!;
                            details['photo_name'] = file!.path;
                          }
                          BlocProvider.of<ProfileBloc>(context).add(
                            EditProfileEvent(
                              profile: details,
                              profileId: widget.profileDetails['id'],
                            ),
                          );
                        }
                      },
                      label: 'Save Changes',
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
