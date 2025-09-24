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
    return BlocProvider(
      create: (context) => SpecialistCubit()..fetchProfile(),
      child: BlocBuilder<SpecialistCubit, SpecialistState>(
        builder: (context, state) {
          if (state is SpecialistLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is SpecialistLoaded) {
            final SpecialistProfile profile = state.profile;

            return Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: profile.profilePicture != null
                      ? NetworkImage(profile.profilePicture!)
                      : null,
                  child: profile.profilePicture == null
                      ? const Icon(Icons.person,
                          size: 28) // الأيقونة الافتراضية
                      : null,
                ),
                const SizedBox(width: 10),
                Text(
                  profile.name,
                  style: GoogleFonts.notoKufiArabic(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          } else if (state is SpecialistFailure) {
            return Text(
              "خطأ: ${state.error}",
              style: const TextStyle(color: Colors.red),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
