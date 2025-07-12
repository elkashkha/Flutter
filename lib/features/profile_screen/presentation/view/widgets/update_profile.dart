import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/emali_fild.dart';
import '../../../../../core/widgets/phone_fild.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String phoneCode = '+20';

  File? _selectedImage;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUserProfile();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _updateProfile() {
    if (formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("جاري تحديث البيانات..."),
              ],
            ),
          );
        },
      );

      context.read<UserCubit>().updateUserProfile(
            name: nameController.text,
            email: emailController.text,
            profilePicture: _selectedImage?.path,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;

    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          nameController.text = state.user.name;
          emailController.text = state.user.email;
          phoneController.text = state.user.phone ?? "رقم الهاتف غير متوفر";
          profileImageUrl = state.user.profilePicture;
        }

        if (state is UserUpdated || state is UserFailure) {
          if (mounted) {
            Navigator.pop(context);
          }
        }

        if (state is UserUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
          );
          context.read<UserCubit>().fetchUserProfile();
        } else if (state is UserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("حدث خطأ: ${state.error}")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.white,
          title: CustomAppBar(
            title: AppLocalizations.of(context)!.edit_profile,
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: size.width * 0.2,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : (profileImageUrl != null
                                    ? NetworkImage(profileImageUrl!)
                                    : const AssetImage(
                                        'assets/images/avatar.png'))
                                as ImageProvider,
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(size.width * 0.015),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.red,
                            size: size.width * 0.06,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  EmailField(
                      taskController: nameController,
                      icon: Icons.person,
                      hint: AppLocalizations.of(context)!.full_name),
                  SizedBox(height: screenHeight * 0.04),
                  EmailField(
                      taskController: emailController,
                      icon: Icons.email,
                      hint: AppLocalizations.of(context)!.email),
                  SizedBox(height: screenHeight * 0.04),
                  // PhoneNumberField(
                  //   controller: phoneController,
                  //   onChanged: (number) {
                  //     if (number.phoneNumber != null) {
                  //       setState(() {
                  //         phoneNumber = number.phoneNumber!;
                  //         phoneCode = number.dialCode!;
                  //       });
                  //     }
                  //   },
                  // ),
                  SizedBox(height: screenHeight * 0.04),
                  MyCustomButton(
                      text: AppLocalizations.of(context)!.update,
                      voidCallback: _updateProfile),
                  SizedBox(height: screenHeight * 0.04),
                  MyCustomButton(
                    voidCallback: () => context.push('/ForgetPasswordBody'),
                    text: AppLocalizations.of(context)!.forgot_password,
                    backgroundColor: AppTheme.white,
                    textColor: AppTheme.primary,
                    borderColor: AppTheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
