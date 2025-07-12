import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/custom_textFild.dart';
import '../../../../../../core/widgets/emali_fild.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../view_model/login_cubit.dart';
import '../../view_model/login_state.dart';

class LoginScreenBody extends StatefulWidget {
  const LoginScreenBody({super.key});

  @override
  _LoginScreenBodyState createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<LoginScreenBody> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomDotsTriangleLoader(),
                  const SizedBox(height: 20),
                  Text(
                    localizations.logging_in,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        } else if (state is LoginSuccess) {
          Navigator.pop(context);
          context.go('/');
        } else if (state is OtpRequired) {
          Navigator.pop(context);
          context.go('/otpVerification', extra: state.email);
        } else if (state is LoginFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10, bottom: 8),
                            child: Text(
                              localizations.welcome_back,
                              style: GoogleFonts.tajawal(
                                textStyle: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  color: AppTheme.primary,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: isArabic ? TextAlign.right : TextAlign.left,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                EmailField(
                                  taskController: emailController,
                                  hint: localizations.enter_email,
                                  icon: Icons.email,
                                  validate: (value) {
                                    if (value!.trim().isEmpty) {
                                      return localizations.email_required;
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                      return localizations.invalid_email;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                CustomTextField(
                                  taskController: passwordController,
                                  hint: localizations.password,
                                  icon: Icons.lock,
                                  ispassword: true,
                                  validate: (value) => value!.length < 8
                                      ? localizations.password_required
                                      : null,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () {
                                      context.push('/ForgetPasswordBody');
                                    },
                                    child: Text(
                                      localizations.forgot_password,
                                      style: const TextStyle(
                                        color: Color(0xffB0AEAE),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                MyCustomButton(
                                  text: localizations.login,
                                  voidCallback: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<LoginCubit>(context).login(
                                        email: emailController.text.trim(),
                                        password: passwordController.text.trim(),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () { context.go('/NavBarView'); },
                              child: Text(isArabic ? 'الدخول كزائر' : 'Continue as Guest',
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.grey)),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.no_account,
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
                                  context.push('/RegisterScreen');
                                },
                                child: Text(
                                  localizations.create_account,
                                  style: GoogleFonts.manjari(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                              ),
                              // Text(
                              //   localizations.no_account,
                              //   style: GoogleFonts.manjari(
                              //     textStyle: TextStyle(
                              //       fontWeight: FontWeight.w400,
                              //       color: Colors.black,
                              //       fontSize: screenWidth * 0.04,
                              //     ),
                              //   ),
                              // ),
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
