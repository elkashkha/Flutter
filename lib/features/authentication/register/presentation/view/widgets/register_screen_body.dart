import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_textFild.dart';
import '../../../../../../core/widgets/emali_fild.dart';
import '../../../../../../core/widgets/phone_fild.dart';
import '../../view_model/register_cubit.dart';
import '../../view_model/register_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({super.key});

  @override
  _RegisterScreenBodyState createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String phoneCode = '+20';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final localization = AppLocalizations.of(context)!;

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.pushReplacement('/otpVerification',
              extra: emailController.text.trim());
        } else if (state is RegisterFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(80)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Text(
                              localization.welcome_message,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  color: AppTheme.primary,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                EmailField(
                                  taskController: nameController,
                                  hint: localization.full_name,
                                  icon: Icons.person,
                                  validate: (value) => value!.trim().isEmpty
                                      ? 'الرجاء إدخال الاسم الكامل'
                                      : null,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                EmailField(
                                  taskController: emailController,
                                  hint: localization.enter_email,
                                  icon: Icons.email,
                                  validate: (value) {
                                    if (value!.trim().isEmpty) {
                                      return localization.pleaseEnterEmail;
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return localization.invalid_email;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                PhoneNumberField(
                                  controller: phoneController,
                                  onChanged: (number) {
                                    if (number.phoneNumber != null) {
                                      setState(() {
                                        phoneNumber = number.phoneNumber!;
                                        phoneCode = number.dialCode!;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                CustomTextField(
                                  taskController: passwordController,
                                  hint: localization.password,
                                  icon: Icons.lock,
                                  ispassword: true,
                                  validate: (value) => value!.length < 8
                                      ? localization.password_short
                                      : null,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                CustomTextField(
                                  taskController: confirmPasswordController,
                                  hint: localization.confirmPassword,
                                  icon: Icons.lock,
                                  ispassword: true,
                                  validate: (value) =>
                                      value != passwordController.text.trim()
                                          ? 'كلمة المرور يجب أن تكون متطابقة'
                                          : null,
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                MyCustomButton(
                                  text: state is RegisterLoading
                                      ? localization.registering
                                      : localization.register,
                                  voidCallback: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<RegisterCubit>(context)
                                          .register(
                                        name: nameController.text.trim(),
                                        email: emailController.text.trim(),
                                        phoneNumber:
                                            phoneController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localization.already_have_account,
                                style: GoogleFonts.manjari(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push('/LoginScreenView');
                                },
                                child: Text(
                                  localization.login,
                                  style: GoogleFonts.manjari(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
