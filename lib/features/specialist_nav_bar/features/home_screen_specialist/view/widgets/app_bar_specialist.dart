import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarSpecialist extends StatelessWidget {
  final String title;
  const AppBarSpecialist({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final specialistCubit = context.read<SpecialistCubit>();
    if (specialistCubit.state is SpecialistInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        specialistCubit.fetchProfile();
      });
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: BlocBuilder<SpecialistCubit, SpecialistState>(
        builder: (context, state) {
          String? profilePicUrl;
          if (state is SpecialistLoaded) {
            profilePicUrl = state.profile.profilePicture;
          }

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title on the right (first child in RTL)
              Text(
                title,
                style: GoogleFonts.notoKufiArabic(
                  color: const Color(0xff0B0B0F),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // CircleAvatar & Menu on the left (second child in RTL)
              Row(
                children: [
                  PopupMenuButton<int>(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xffF7F7F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.menu,
                        size: 20,
                        color: Color(0xff0B0B0F),
                      ),
                    ),
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                        context.push('/BookingSpecialistScreen');
                      } else if (value == 1) {
                        context.push('/NotificationsScreen');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(Icons.folder, color: Colors.white),
                            SizedBox(width: 10),
                            Text("الحجوزات", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.notifications, color: Colors.white),
                            SizedBox(width: 10),
                            Text("الاشعارات", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: profilePicUrl != null
                        ? NetworkImage(profilePicUrl)
                        : null,
                    child: profilePicUrl == null
                        ? const Icon(Icons.person, size: 20, color: Colors.grey)
                        : null,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
