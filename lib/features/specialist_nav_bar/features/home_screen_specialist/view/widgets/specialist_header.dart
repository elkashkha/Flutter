import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_model.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialistHeaderBlocWidget extends StatelessWidget {
  const SpecialistHeaderBlocWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialistCubit, SpecialistState>(
      builder: (context, state) {
        if (state is SpecialistLoading) {
          return const Center(child: CustomDotsTriangleLoader());
        } else if (state is SpecialistLoaded) {
          final SpecialistProfile profile = state.profile;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Profile Avatar on the right (first child in RTL)
                CircleAvatar(
                  radius: 28,
                  backgroundImage: profile.profilePicture != null
                      ? NetworkImage(profile.profilePicture!)
                      : null,
                  child: profile.profilePicture == null
                      ? const Icon(Icons.person, size: 28)
                      : null,
                ),
                const SizedBox(width: 12),
                // Name and monthly bookings next to it
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: GoogleFonts.notoKufiArabic(
                        color: const Color(0xff0B0B0F),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'حجوزاتك لهذا الشهر : ${profile.sessionsCount}',
                      style: GoogleFonts.notoKufiArabic(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Stars rating on the left (last child in RTL)
                Row(
                  children: List.generate(5, (index) {
                    final isFilled = index < profile.overallRating.floor();
                    return Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                ),
              ],
            ),
          );
        } else if (state is SpecialistFailure) {
          return Text(
            "خطأ: ${state.error}",
            style: const TextStyle(color: Colors.red),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
