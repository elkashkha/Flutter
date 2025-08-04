import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/services.dart';
import '../../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textFild.dart';
import '../view_model/forget_password_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ResetPasswordBody extends StatefulWidget {
  const ResetPasswordBody({super.key});

  @override
  _ResetPasswordBodyState createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final localization = AppLocalizations.of(context)!;


    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.05),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localization.resetPassword,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              localization.enterOtpCode,
              style: GoogleFonts.tajawal(
                textStyle: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: AppTheme.gray,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                length: 6,
                appContext: context,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (code) => setState(() => otpCode = code),
                onCompleted: (code) => setState(() => otpCode = code),
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  fieldHeight: screenHeight * 0.06,
                  fieldWidth: screenWidth * 0.12,
                  activeColor: AppTheme.primary,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              taskController: passwordController,
              hint: localization.enterNewPassword,
              icon: Icons.lock,
              ispassword: true,
              validate: (value) {
                if (value!.trim().isEmpty) return "يجب إدخال كلمة المرور";
                if (value.length < 8) return "يجب أن تتكون كلمة المرور من 8 أحرف على الأقل";
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            CustomTextField(
              taskController: confirmPasswordController,
              hint: localization.confirmPassword,
              icon: Icons.lock,
              ispassword: true,
              validate: (value) {
                if (value!.trim().isEmpty) return "يجب تأكيد كلمة المرور";
                if (value != passwordController.text) return "كلمتا المرور غير متطابقتين";
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.04),
            BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
              listener: (context, state) {
                if (state is ForgetPasswordSuccess) {
                  _showSuccessDialog(context);
                } else if (state is ForgetPasswordError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return MyCustomButton(
                  text: state is ForgetPasswordLoading ? "جارٍ التحديث..." : "تأكيد",
                  voidCallback: state is ForgetPasswordLoading
                      ? null
                      : () {
                    if (_formKey.currentState!.validate() && otpCode.length == 6) {
                      context.read<ForgetPasswordCubit>().resetPassword(
                        email,
                        otpCode,
                        passwordController.text,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("يرجى إدخال رمز تحقق صالح")),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/undraw_agree_g19h (2) 1.png',
                  width: 200,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  localization.passwordResetSuccess,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.go('/LoginScreenView');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Text(
                      localization.homePage,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}