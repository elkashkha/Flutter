import 'dart:async';
import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../register/presentation/view_model/register_cubit.dart';
import '../register/presentation/view_model/register_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  Timer? _timer;
  int _remainingSeconds = 600;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
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
                  'assets/images/undraw_agree_g19h (2) 1شيشسي.png',
                  width: 200,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                 Text(
                  localization.account_created_success,
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            _showSuccessDialog(context);
          } else if (state is OtpVerificationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(height: screenHeight * 0.08),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(screenWidth * 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.04,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          localization.otp_verification_message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: PinCodeTextField(
                              cursorColor: AppTheme.primary,
                              appContext: context,
                              length: 6,
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                fieldHeight: screenHeight * 0.06,
                                fieldWidth: screenWidth * 0.10,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.grey[200]!,
                                activeColor: AppTheme.primary,
                                selectedFillColor: AppTheme.primary.withOpacity(0.2),
                                selectedColor: AppTheme.primary,
                                inactiveColor: Colors.grey,
                              ),
                              onChanged: (value) {},
                            ),
                          ),

                        ),
                        SizedBox(height: screenHeight * 0.04),
                        MyCustomButton(
                          text: localization.verify_button,
                          voidCallback: state is OtpVerificationLoading
                              ? null
                              : () {
                                  BlocProvider.of<RegisterCubit>(context)
                                      .verifyOtp(
                                    email: widget.email,
                                    otpCode: otpController.text.trim(),
                                  );
                                },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextButton(
                          onPressed: _remainingSeconds == 0
                              ? () => BlocProvider.of<RegisterCubit>(context)
                                  .sendOtp(email: widget.email)
                              : null,
                          child: Text(
          localization.resend_code,
                            style: TextStyle(
                              color: _remainingSeconds == 0
                                  ? AppTheme.primary
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Text(
                          AppLocalizations.of(context)!.code_expires_in(_formattedTime),
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    super.dispose();
  }
}
