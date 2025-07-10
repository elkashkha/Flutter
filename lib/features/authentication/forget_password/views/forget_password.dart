import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/emali_fild.dart';
import '../view_model/forget_password_cubit.dart';

class ForgetPasswordBody extends StatelessWidget {
  ForgetPasswordBody({super.key});
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
          top: screenWidth * 0.05,
          right: screenWidth * 0.04,
          left: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localization.enterEmailToReceiveCode,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.042,
                color: AppTheme.primary,
                height: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            localization.verificationCodeWillBeSent,
            style: GoogleFonts.tajawal(
              textStyle: TextStyle(
                fontSize: screenWidth * 0.042,
                color: AppTheme.gray,
                height: 1.5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          EmailField(
            taskController: emailController,
            hint: localization.enterYourEmail,
            validate: (value) {
              if (value!.trim().isEmpty) {
                return localization.pleaseEnterEmail;
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return localization.enterValidEmail;
              }
              return null;
            },
            icon: Icons.email,
          ),
          SizedBox(height: screenHeight * 0.03),
          BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
            listener: (context, state) {
              if (state is ForgetPasswordCodeSent) {
                context.pushReplacement('/RestPassword',
                    extra: emailController.text);
              } else if (state is ForgetPasswordError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message,
                        style: const TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              return MyCustomButton(
                text: state is ForgetPasswordLoading
                    ? localization.sendingCode
                    : localization.sendCode,
                voidCallback: state is ForgetPasswordLoading
                    ? null
                    : () {
                  context
                      .read<ForgetPasswordCubit>()
                      .sendResetCode(emailController.text);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
