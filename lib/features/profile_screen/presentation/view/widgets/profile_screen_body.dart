import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/change_language_cubit/change_language_cubit.dart';
import '../../../../authentication/login/presentation/view_model/login_cubit.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().fetchUserProfile();
    });

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 310,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 50),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UserFailure &&
                      state.error == "انتهت صلاحيه تسجيل الدخول ") {
                    _showSessionExpiredDialog(context);
                  }
                },
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const CustomDotsTriangleLoader(color: Colors.white);
                  } else if (state is UserLoaded) {
                    final user = state.user;
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.profilePicture != null
                              ? NetworkImage(user.profilePicture!)
                              : const AssetImage('assets/profile.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/cup.svg',
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  user.accountType!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/cup2.svg',
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  user.points.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is UserFailure) {
                    return Text(
                      "${locale.error_occurred} ${state.error}",
                      style: const TextStyle(color: Colors.white),
                    );
                  } else if (state is UserNotLoggedIn) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'انت غير مسجل الدخول!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'سجل دخولك او انشئ حساب للاستفادة من جميع خدماتنا',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          MyCustomButton(
                            text: locale.login,
                            voidCallback: () {
                              context.push('/LoginScreenView');
                            },
                            borderColor: AppTheme.white,
                          )
                        ],
                      ),
                    );
                  }
                  return const Text(
                    "",
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          top: 240,
          left: 0,
          right: 0,
          bottom: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 250,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state is UserLoaded) ...[
                        _buildProfileOption(locale.edit_profile, Icons.person,
                            onTap: () {
                          context.push('/UpdateProfile');
                        }),
                      ],
                      _buildProfileOption(
                          locale.notifications, Icons.notifications, onTap: () {
                        context.push('/NotificationsScreen');
                      }),
                      _buildProfileOption(
                          'الهدايا', Icons.wallet_giftcard_rounded, onTap: () {
                        if (state is UserLoaded) {
                          context.push('/GiftsScreen', extra: {
                            'accountType': state.user.accountType,
                            'points': state.user.points,
                          });
                        } else {
                          context.push('/GiftsScreen', extra: {});
                        }
                      }),
                      _buildLanguageOption(context),
                      _buildProfileOption(locale.about_us, Icons.info,
                          onTap: () {
                        context.push("/AboutUs");
                      }),
                      _buildProfileOption(locale.contact_us, Icons.phone,
                          onTap: () {
                        context.push('/ContactUs');
                      }),
                      _buildProfileOption(locale.my_booking, Icons.bookmark_add,
                          onTap: () {
                        context.push('/BookingsScreen');
                      }),
                      _buildProfileOption(
                          locale.privacy_policy, Icons.privacy_tip, onTap: () {
                        context.push('/PoliciesView');
                      }),
                      const SizedBox(height: 10),
                      if (state is UserLoaded) ...[
                        _buildDeleteAccountOption(context),
                        const SizedBox(height: 10),
                        _buildLogoutOption(context),
                      ],
                      if (state is UserNotLoggedIn) ...[
                        _buildProfileOption(locale.login, Icons.login,
                            onTap: () {
                          context.go('/LoginScreenView');
                        }),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSessionExpiredDialog(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SizedBox(
          height: 450,
          width: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/close.svg',
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                localization.session_expired,
                style: GoogleFonts.notoNaskhArabic(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                localization.session_expired_message,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              MyCustomButton(
                  text: localization.login,
                  backgroundColor: Colors.black,
                  voidCallback: () async {
                    Navigator.pop(context);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('access_token');
                    if (context.mounted) {
                      context.go('/LoginScreenView');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon,
      {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, color: Colors.black),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return ListTile(
              leading: const Icon(Icons.language, color: Colors.black),
              title: Text(
                localization.language,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: DropdownButton<String>(
                value: state.languageCode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<LanguageCubit>().changeLanguage(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDeleteAccountOption(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          title: Text(
            localization.delete_account,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(localization.delete_account),
                content: Text(localization.delete_account_confirm),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(localization.cancel),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/LoginScreenView');
                      BlocProvider.of<LoginCubit>(context).deleteUser(context);
                    },
                    child: Text(
                      localization.confirm,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogoutOption(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: const Icon(Icons.exit_to_app, color: Colors.red),
          title: Text(
            localization.login_out,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');

            if (context.mounted) {
              context.go('/LoginScreenView');
            }
          },
        ),
      ),
    );
  }
}
