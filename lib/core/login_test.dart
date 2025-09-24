// // // import 'package:bloc/bloc.dart';
// // // import 'package:dio/dio.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:go_router/go_router.dart';
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:firebase_messaging/firebase_messaging.dart';

// // // import 'login_state.dart';

// // // class LoginCubit extends Cubit<LoginState> {
// // //   LoginCubit() : super(LoginInitial());

// // //   final Dio _dio = Dio(BaseOptions(
// // //     baseUrl: 'https://apitest.alkashkhaa.com/public/api/',
// // //     contentType: 'application/json',
// // //   ));

// // //   Future<void> login({
// // //     required String email,
// // //     required String password,
// // //   }) async {
// // //     emit(LoginLoading());
// // //     try {
// // //       Response response = await _dio.post(
// // //         'user/login',
// // //         data: {
// // //           "email": email,
// // //           "password": password,
// // //         },
// // //       );

// // //       if (response.statusCode == 200 && response.data['access_token'] != null) {
// // //         String token = response.data['access_token'];
// // //         int userId = response.data['user']['id'];
// // //         String type = response.data['type'];

// // //         await _saveAuthData(token, userId, type);
// // //         emit(LoginSuccess(token, userId, type));

// // //         await sendFcmTokenToServer();
// // //       } else {
// // //         emit(LoginFailure("فشل تسجيل الدخول، تحقق من البيانات."));
// // //       }
// // //     } on DioException catch (e) {
// // //       if (e.response != null && e.response!.statusCode == 403) {
// // //         if (e.response!.data != null &&
// // //             e.response!.data['message'] ==
// // //                 "Email not verified. OTP sent to email for verification.") {
// // //           emit(OtpRequired(email));
// // //         } else {
// // //           emit(LoginFailure(_handleDioError(e)));
// // //         }
// // //       } else {
// // //         emit(LoginFailure(_handleDioError(e)));
// // //       }
// // //     }
// // //   }

// // //   Future<void> deleteUser(BuildContext context) async {
// // //     emit(LoginLoading());

// // //     try {
// // //       int? userId = await getUserId();

// // //       if (userId == null) {
// // //         emit(LoginFailure("المستخدم غير مسجل."));
// // //         return;
// // //       }

// // //       String url = 'user/$userId';

// // //       Response response = await _dio.delete(url);

// // //       if (response.statusCode == 200) {
// // //         await _clearAuthData();
// // //         if (context.mounted) {
// // //           context.go('/LoginScreenView');
// // //         }
// // //       } else {
// // //         emit(LoginFailure("فشل في حذف المستخدم."));
// // //       }
// // //     } on DioException catch (e) {
// // //       emit(LoginFailure(_handleDioError(e)));
// // //     } catch (e) {
// // //       emit(LoginFailure("حدث خطأ غير متوقع."));
// // //     }
// // //   }

// // //   Future<void> sendFcmTokenToServer() async {
// // //     try {
// // //       final String? token = await getToken();
// // //       final int? userId = await getUserId();
// // //       final String? fcmToken = await FirebaseMessaging.instance.getToken();

// // //       if (token == null || userId == null || fcmToken == null) {
// // //         print("❌ البيانات ناقصة، مش هينفع نكمل إرسال التوكن");
// // //         return;
// // //       }

// // //       final response = await Dio().post(
// // //         'https://api.alkashkhaa.com/public/api/notifications/save-token',
// // //         data: {
// // //           "fcm_token": fcmToken,
// // //         },
// // //         options: Options(
// // //           headers: {
// // //             "Authorization": "Bearer $token",
// // //             "Accept": "application/json",
// // //           },
// // //           followRedirects: false,
// // //           validateStatus: (status) => status != null && status < 500,
// // //         ),
// // //       );

// // //       print("Status Code: ${response.statusCode}");
// // //       print("Response: ${response.data}");

// // //       if (response.statusCode == 200) {
// // //         print("✅ تم إرسال FCM Token بنجاح");
// // //       } else {
// // //         print("⚠️ فشل إرسال FCM Token: ${response.statusCode}");
// // //       }
// // //     } catch (e) {
// // //       print("🚨 خطأ أثناء إرسال FCM Token: $e");
// // //     }
// // //   }

// // //   Future<void> _saveAuthData(String token, int userId, String type) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.setString('access_token', token);
// // //     await prefs.setInt('user_id', userId);
// // //     await prefs.setString('user_type', type);
// // //   }

// // //   Future<String?> getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString('access_token');
// // //   }

// // //   Future<int?> getUserId() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getInt('user_id');
// // //   }

// // //   Future<void> _clearAuthData() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     await prefs.remove('access_token');
// // //     await prefs.remove('user_id');
// // //     await prefs.remove('user_type');
// // //   }

// // //   String _handleDioError(DioException e) {
// // //     if (e.response != null) {
// // //       if (e.response!.statusCode == 401) {
// // //         return "البريد الإلكتروني أو كلمة المرور غير صحيحة.";
// // //       } else if (e.response!.data != null &&
// // //           e.response!.data['message'] != null) {
// // //         return e.response!.data['message'];
// // //       }
// // //     }
// // //     return "خطأ في الاتصال بالسيرفر.";
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:go_router/go_router.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// // import '../../../../../../core/app_theme.dart';
// // import '../../../../../../core/widgets/custom_button.dart';
// // import '../../../../../../core/widgets/custom_textFild.dart';
// // import '../../../../../../core/widgets/emali_fild.dart';
// // import '../../../../../../core/widgets/loading.dart';
// // import '../../view_model/login_cubit.dart';
// // import '../../view_model/login_state.dart';

// // class LoginScreenBody extends StatefulWidget {
// //   const LoginScreenBody({super.key});

// //   @override
// //   _LoginScreenBodyState createState() => _LoginScreenBodyState();
// // }

// // class _LoginScreenBodyState extends State<LoginScreenBody> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

// //   @override
// //   Widget build(BuildContext context) {
// //     final mediaQuery = MediaQuery.of(context);
// //     final screenHeight = mediaQuery.size.height;
// //     final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
// //     final localizations = AppLocalizations.of(context)!;
// //     final isArabic = Localizations.localeOf(context).languageCode == 'ar';

// //     return BlocConsumer<LoginCubit, LoginState>(
// //       listener: (context, state) {
// //         if (state is LoginLoading) {
// //           showDialog(
// //             context: context,
// //             barrierDismissible: false,
// //             builder: (context) => AlertDialog(
// //               backgroundColor: Colors.white,
// //               content: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   const CustomDotsTriangleLoader(),
// //                   const SizedBox(height: 20),
// //                   Text(
// //                     localizations.logging_in,
// //                     style: const TextStyle(fontSize: 16),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         } else if (state is LoginSuccess) {
// //           Navigator.pop(context);

// //           if (state.type == "user") {
// //             context.go('/NavBarView');
// //           } else {
// //             context.go('/SpecialistNavBarView');
// //           }
// //         }
// //         else if (state is OtpRequired) {
// //           Navigator.pop(context);
// //           context.go('/otpVerification', extra: state.email);
// //         } else if (state is LoginFailure) {
// //           Navigator.pop(context);
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(state.error), backgroundColor: Colors.red),
// //           );
// //         }
// //       },
// //       builder: (context, state) {
// //         return Padding(
// //           padding: const EdgeInsets.only(top: 20.0),
// //           child: Column(
// //             children: [
// //               Expanded(
// //                 child: Container(
// //                   decoration: const BoxDecoration(
// //                     color: Colors.white,
// //                     borderRadius: BorderRadius.only(topRight: Radius.circular(80)),
// //                   ),
// //                   child: SingleChildScrollView(
// //                     child: Padding(
// //                       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
// //                       child: Column(
// //                         crossAxisAlignment: isArabic
// //                             ? CrossAxisAlignment.end
// //                             : CrossAxisAlignment.start,
// //                         children: [
// //                           Padding(
// //                             padding: const EdgeInsets.only(top: 25.0, left: 10, right: 10, bottom: 8),
// //                             child: Text(
// //                               localizations.welcome_back,
// //                               style: GoogleFonts.tajawal(
// //                                 textStyle: TextStyle(
// //                                   fontSize: screenWidth * 0.042,
// //                                   color: AppTheme.primary,
// //                                   height: 1.5,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                               ),
// //                               textAlign: isArabic ? TextAlign.right : TextAlign.left,
// //                             ),
// //                           ),
// //                           SizedBox(height: screenHeight * 0.02),
// //                           Form(
// //                             key: formKey,
// //                             child: Column(
// //                               children: [
// //                                 EmailField(
// //                                   taskController: emailController,
// //                                   hint: localizations.enter_email,
// //                                   icon: Icons.email,
// //                                   validate: (value) {
// //                                     if (value!.trim().isEmpty) {
// //                                       return localizations.email_required;
// //                                     }
// //                                     if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
// //                                       return localizations.invalid_email;
// //                                     }
// //                                     return null;
// //                                   },
// //                                 ),
// //                                 SizedBox(height: screenHeight * 0.02),
// //                                 CustomTextField(
// //                                   taskController: passwordController,
// //                                   hint: localizations.password,
// //                                   icon: Icons.lock,
// //                                   ispassword: true,
// //                                   validate: (value) => value!.length < 8
// //                                       ? localizations.password_required
// //                                       : null,
// //                                 ),
// //                                 SizedBox(height: screenHeight * 0.02),
// //                                 Align(
// //                                   alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
// //                                   child: TextButton(
// //                                     onPressed: () {
// //                                       context.push('/ForgetPasswordBody');
// //                                     },
// //                                     child: Text(
// //                                       localizations.forgot_password,
// //                                       style: const TextStyle(
// //                                         color: Color(0xffB0AEAE),
// //                                         fontSize: 14,
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SizedBox(height: screenHeight * 0.02),
// //                                 MyCustomButton(
// //                                   text: localizations.login,
// //                                   voidCallback: () {
// //                                     if (formKey.currentState!.validate()) {
// //                                       BlocProvider.of<LoginCubit>(context).login(
// //                                         email: emailController.text.trim(),
// //                                         password: passwordController.text.trim(),
// //                                       );
// //                                     }
// //                                   },
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                           Center(
// //                             child: TextButton(
// //                               onPressed: () { context.go('/NavBarView'); },
// //                               child: Text(isArabic ? 'الدخول كزائر' : 'Continue as Guest',
// //                                   style: TextStyle(
// //                                       fontSize: screenWidth * 0.035,
// //                                       color: Colors.grey)),
// //                             ),
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               Text(
// //                                 localizations.no_account,
// //                                 style: GoogleFonts.manjari(
// //                                   textStyle: TextStyle(
// //                                     fontWeight: FontWeight.w400,
// //                                     color: Colors.black,
// //                                     fontSize: screenWidth * 0.04,
// //                                   ),
// //                                 ),
// //                               ),
// //                               TextButton(
// //                                 onPressed: () {
// //                                   context.push('/RegisterScreen');
// //                                 },
// //                                 child: Text(
// //                                   localizations.create_account,
// //                                   style: GoogleFonts.manjari(
// //                                     textStyle: TextStyle(
// //                                       fontWeight: FontWeight.bold,
// //                                       color: AppTheme.primary,
// //                                       fontSize: screenWidth * 0.05,
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ),
// //                               // Text(
// //                               //   localizations.no_account,
// //                               //   style: GoogleFonts.manjari(
// //                               //     textStyle: TextStyle(
// //                               //       fontWeight: FontWeight.w400,
// //                               //       color: Colors.black,
// //                               //       fontSize: screenWidth * 0.04,
// //                               //     ),
// //                               //   ),
// //                               // ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// import 'dart:ui';
// import 'package:flutter/animation.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:go_router/go_router.dart';

// class SplashViewBody extends StatefulWidget {
//   const SplashViewBody({super.key});

//   @override
//   State<SplashViewBody> createState() => _SplashViewBodyState();
// }

// class _SplashViewBodyState extends State<SplashViewBody>
//     with TickerProviderStateMixin {
//   late AnimationController fadeController;
//   late Animation<double> fadeAnimation;
//   late Animation<Offset> slideAnimation;
//   late AnimationController bounceController;
//   late Animation<double> bounceAnimation;

//   @override
//   void initState() {
//     super.initState();
//     initFadeAnimation();
//     initBounceAnimation();
//     navigateToNextScreen();
//   }

//   @override
//   void dispose() {
//     fadeController.dispose();
//     bounceController.dispose();
//     super.dispose();
//   }

//   void initFadeAnimation() {
//     fadeController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     );
//     fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
//     );
//     slideAnimation = Tween<Offset>(
//       begin: const Offset(1, 0),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

//     Future.delayed(const Duration(seconds: 1), () {
//       fadeController.forward();
//     });
//   }

//   void initBounceAnimation() {
//     bounceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );
//     bounceAnimation = Tween<double>(begin: 1, end: 1.2).animate(
//       CurvedAnimation(parent: bounceController, curve: Curves.bounceOut),
//     );
//     bounceController.repeat(reverse: true);
//   }

//   Future<void> navigateToNextScreen() async {
//     await Future.delayed(const Duration(seconds: 3));

//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('access_token');
//     final type = prefs.getString('user_type');
//     final seenOnBoarding = prefs.getBool('seenOnBoarding') ?? false;

//     if (mounted) {
//       if (token != null && type != null) {
//         if (type == "user") {
//           context.go('/NavBarView');
//         } else {
//           context.go('/SpecialistNavBarView');
//         }
//       } else if (seenOnBoarding) {
//         context.go('/LoginScreenView');
//       } else {
//         context.go('/OnBoardingView');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = MediaQuery.of(context).size.width > 600
//         ? MediaQuery.of(context).size.width * .75
//         : MediaQuery.of(context).size.width;

//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SlideTransition(
//             position: slideAnimation,
//             child: FadeTransition(
//               opacity: fadeAnimation,
//               child: ScaleTransition(
//                 scale: bounceAnimation,
//                 child: Image.asset(
//                   'assets/images/cut.gif',
//                   width: screenWidth * 0.2,
//                   height: 150,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(-1, 0),
//               end: Offset.zero,
//             ).animate(CurvedAnimation(
//                 parent: fadeController, curve: Curves.easeInOut)),
//             child: FadeTransition(
//               opacity: fadeAnimation,
//               child: Image.asset(
//                 'assets/images/الكشخة_page-0001 1.png',
//                 width: screenWidth * 0.4,
//                 height: 200,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
