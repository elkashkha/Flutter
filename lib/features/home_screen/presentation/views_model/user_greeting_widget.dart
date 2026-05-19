import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../profile_screen/presentation/view_model/user_cubit.dart';
import '../../../profile_screen/presentation/view_model/user_state.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          final profilePicUrl = state.user.profilePicture;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // 1. User Profile Picture
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: profilePicUrl != null && profilePicUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: profilePicUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                              padding: const EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.white : Colors.black),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                              child: Icon(Icons.person, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400, size: 24),
                            ),
                          )
                        : Container(
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                            child: Icon(Icons.person, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400, size: 24),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                // 2. Greeting and Name in one line
                Expanded(
                  child: Text(
                    "${localization.hello}, ${state.user.name}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.tajawal(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state is UserFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "حدث خطأ أثناء تحميل الاسم",
              style: GoogleFonts.tajawal(color: isDark ? Colors.white70 : Colors.black87),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "جاري التحميل...",
            style: GoogleFonts.tajawal(color: isDark ? Colors.white70 : Colors.black87),
          ),
        );
      },
    );
  }
}
