import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/change_language_cubit/change_language_cubit.dart';
import '../../../../../core/theme_cubit/theme_cubit.dart';
import '../../../../authentication/login/presentation/view_model/login_cubit.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

class ProfileScreenBody extends StatefulWidget {
  const ProfileScreenBody({super.key});

  @override
  State<ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<ProfileScreenBody> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCubit>().fetchUserProfile();
    });
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
                    await prefs.remove('user_type');

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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final localeOf = Localizations.localeOf(context);
    final isArabic = localeOf.languageCode == 'ar';
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkMode = themeCubit.state.themeMode == ThemeMode.dark;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserFailure &&
            state.error == "انتهت صلاحيه تسجيل الدخول ") {
          _showSessionExpiredDialog(context);
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CustomDotsTriangleLoader(color: Colors.black));
        }

        // We will build a beautiful clean white layout just like the image
        return Scaffold(
          backgroundColor: isDark ? const Color(0xff0B0B0F) : Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header with back arrow and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Space or back button depending on standard
                      IconButton(
                        icon: Icon(
                          isArabic ? Icons.arrow_back : Icons.arrow_forward,
                          color: isDark ? Colors.white : Colors.black,
                          size: 26,
                        ),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          } else {
                            context.go('/NavBarView');
                          }
                        },
                      ),
                      Text(
                        isArabic ? 'الملف الشخصي' : 'Profile',
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to center the title
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Profile Details Card
                  if (state is UserLoaded) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: state.user.profilePicture ??
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKz9XsUJfaO-reUJ2o12yPP6I664jwnLfH8A&s',
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.account_circle, size: 65, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.user.name,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  state.user.email,
                                  style: GoogleFonts.tajawal(
                                    fontSize: 14,
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Dynamic Single Tier Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                          decoration: BoxDecoration(
                            color: state.user.accountType == 'ذهبي'
                                ? (isDark ? const Color(0xFF332A15) : const Color(0xFFFEF9E7))
                                : (isDark ? const Color(0xFF2C2B2B) : const Color(0xFFF2F4F4)),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: state.user.accountType == 'ذهبي'
                                  ? const Color(0xFFF5B041)
                                  : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.user.accountType == 'ذهبي'
                                    ? Icons.workspace_premium_outlined
                                    : Icons.workspace_premium_outlined,
                                color: state.user.accountType == 'ذهبي'
                                    ? const Color(0xFFF5B041)
                                    : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                state.user.accountType == 'ذهبي'
                                    ? (isArabic ? 'ذهبي' : 'Gold')
                                    : (isArabic ? 'عادي' : 'Regular'),
                                style: GoogleFonts.tajawal(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: state.user.accountType == 'ذهبي'
                                      ? const Color(0xFFF5B041)
                                      : (isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else if (state is UserNotLoggedIn) ...[
                    // Standard Not Logged In banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'أنت غير مسجل الدخول!' : 'You are not logged in!',
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isArabic
                                ? 'سجل دخولك أو أنشئ حساباً للاستفادة من جميع خدماتنا'
                                : 'Login or create an account to enjoy all our services',
                            style: GoogleFonts.tajawal(
                              fontSize: 14,
                              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyCustomButton(
                            text: locale.login,
                            backgroundColor: isDark ? const Color(0xff262626) : Colors.black,
                            voidCallback: () {
                              context.push('/LoginScreenView');
                            },
                          )
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 4. Menu Options Container (A single rounded container)
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Option 1: Edit Profile (Only for Logged In users)
                        if (state is UserLoaded) ...[
                          _buildMenuItem(
                            title: locale.edit_profile,
                            icon: Icons.person_outline,
                            onTap: () => context.push('/UpdateProfile'),
                            isArabic: isArabic,
                          ),
                          _buildDivider(),
                        ],

                        // Option 2: Notifications
                        _buildMenuItem(
                          title: locale.notifications,
                          icon: Icons.notifications_none_outlined,
                          onTap: () => context.push('/NotificationsScreen'),
                          isArabic: isArabic,
                        ),
                        _buildDivider(),

                        // Option 3: Bookings
                        _buildMenuItem(
                          title: locale.my_booking,
                          icon: Icons.calendar_today_outlined,
                          onTap: () => context.push('/BookingsScreen'),
                          isArabic: isArabic,
                        ),
                        _buildDivider(),

                        // Option 4: Language
                        _buildLanguageMenuItem(context, isArabic: isArabic),
                        _buildDivider(),

                        // Option 5: Points (or Gifts)
                        _buildMenuItem(
                          title: isArabic ? 'النقاط والهدايا' : 'Points & Gifts',
                          icon: Icons.stars_outlined,
                          onTap: () {
                            if (state is UserLoaded) {
                              context.push('/GiftsScreen', extra: {
                                'accountType': state.user.accountType,
                                'points': state.user.points,
                              });
                            } else {
                              context.push('/GiftsScreen', extra: {});
                            }
                          },
                          isArabic: isArabic,
                        ),
                        _buildDivider(),

                        // Option 6: Dark Mode (Switch)
                        _buildSwitchMenuItem(
                          title: isArabic ? 'الوضع الداكن' : 'Dark Mode',
                          icon: Icons.dark_mode_outlined,
                          value: isDarkMode,
                          onChanged: (val) {
                            themeCubit.changeTheme(val ? ThemeMode.dark : ThemeMode.light);
                          },
                        ),
                        _buildDivider(),

                        // Option 7: About Us
                        _buildMenuItem(
                          title: locale.about_us,
                          icon: Icons.info_outline,
                          onTap: () => context.push("/AboutUs"),
                          isArabic: isArabic,
                        ),
                        _buildDivider(),

                        // Option 8: Contact Us
                        _buildMenuItem(
                          title: locale.contact_us,
                          icon: Icons.phone_outlined,
                          onTap: () => context.push('/ContactUs'),
                          isArabic: isArabic,
                        ),
                        _buildDivider(),

                        // Option 9: Privacy Policy
                        _buildMenuItem(
                          title: locale.privacy_policy,
                          icon: Icons.privacy_tip_outlined,
                          onTap: () => context.push('/PoliciesView'),
                          isArabic: isArabic,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 5. Delete Account & Logout Options (Red colored, separate)
                  if (state is UserLoaded) ...[
                    _buildDangerButton(
                      title: locale.delete_account,
                      icon: Icons.delete_outline,
                      onTap: () => _showDeleteConfirmDialog(context, locale),
                    ),
                    const SizedBox(height: 12),
                    _buildDangerButton(
                      title: locale.login_out,
                      icon: Icons.exit_to_app_outlined,
                      onTap: () => _handleLogout(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isArabic,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87, size: 24),
      title: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      trailing: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: Icon(
          isArabic ? Icons.arrow_forward : Icons.arrow_back,
          size: 14,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchMenuItem({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87, size: 24),
      title: Text(
        title,
        style: GoogleFonts.tajawal(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.grey.shade600,
        inactiveThumbColor: isDark ? Colors.grey.shade800 : Colors.white,
        inactiveTrackColor: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildLanguageMenuItem(BuildContext context, {required bool isArabic}) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Icon(Icons.language_outlined, color: isDark ? Colors.white70 : Colors.black87, size: 24),
          title: Text(
            localization.language,
            style: GoogleFonts.tajawal(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
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
            icon: Icon(Icons.arrow_drop_down, color: isDark ? Colors.white70 : Colors.black),
            dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            style: GoogleFonts.tajawal(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDangerButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D1F1F) : const Color(0xFFFDF2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: isDark ? const Color(0xFFF87171) : Colors.red.shade700, size: 24),
        title: Text(
          title,
          style: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFFF87171) : Colors.red.shade700,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDivider() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      thickness: 1,
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, AppLocalizations localization) {
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
  }

  Future<void> _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('fcm_token');
    await prefs.remove('user_type');

    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      debugPrint('Failed to delete FCM token: $e');
    }

    if (context.mounted) {
      context.go('/LoginScreenView');
    }
  }
}
