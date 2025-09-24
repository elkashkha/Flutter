import 'dart:io';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/emali_fild.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/cubit/update_profile_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/cubit/update_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../core/app_theme.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  String? selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateSpecialistProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("تحديث البروفايل"),
          backgroundColor: AppTheme.white,
          centerTitle: true,
        ),
        body: BlocConsumer<UpdateSpecialistProfileCubit, UpdateProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            bool isLoading = state is UpdateProfileLoading;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // صورة البروفايل
                      GestureDetector(
                        onTap: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() => selectedImagePath = image.path);
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(color: Colors.grey, width: 2),
                            image: selectedImagePath != null
                                ? DecorationImage(
                                    image: FileImage(File(selectedImagePath!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: selectedImagePath == null
                              ? const Icon(Icons.add_a_photo, size: 40)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // حقل الاسم
                      EmailField(
                        taskController: _nameController,
                        hint: "الاسم",
                        icon: Icons.person,
                        validate: (v) => null, // مش مطلوب دلوقتي
                      ),
                      const SizedBox(height: 24),

                      // زر التحديث
                      MyCustomButton(
                        text: "تحديث البروفايل",
                        isLoading: isLoading,
                        voidCallback: () {
                          final nameText = _nameController.text.trim();
                          context
                              .read<UpdateSpecialistProfileCubit>()
                              .updateProfile(
                                profilePicturePath: selectedImagePath,
                                name: nameText.isNotEmpty
                                    ? nameText
                                    : null, // لو فاضي يبقى null
                              );
                        },
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
