import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../view_model/specialist_model.dart';
import '../../view_model/specialist_profile__cubit.dart';
import '../../view_model/specialist_profile__state.dart';

class ProfileSpecialist extends StatelessWidget {
  const ProfileSpecialist({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => SpecialistCubit()..fetchProfile(),
      child: BlocBuilder<SpecialistCubit, SpecialistState>(
        builder: (context, state) {
          if (state is SpecialistLoading) {
            return const Center(
              child: CustomDotsTriangleLoader(),
            );
          } else if (state is SpecialistLoaded) {
            final SpecialistProfile profile = state.profile;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // ====== Header ======
                  Container(
                    height: 250,
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 40, bottom: 30),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: profile.profilePicture != null
                              ? NetworkImage(profile.profilePicture!)
                              : null,
                          child: profile.profilePicture == null
                              ? const Icon(Icons.person,
                                  size: 28) // الأيقونة الافتراضية
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          profile.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          profile.status,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // ====== Body ======
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 117,
                          width: 326,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    profile.email,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        context.push('/UpdateProfileScreen');
                                      },
                                      child: const Icon(
                                          Icons.mode_edit_outline_outlined)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Email & Phone & Branch

                        // const SizedBox(height: 5),
                        // Text("01293948448",
                        //     style: const TextStyle(
                        //         fontSize: 14, color: Colors.black87)),
                        // const SizedBox(height: 5),
                        // Text("متخصص فرع : التجمع الخامس",
                        //     style: const TextStyle(
                        //         fontSize: 14, color: Colors.black54)),

                        SizedBox(height: 20),

                        // الخبرة
                        Row(
                          children: [
                            const Text("الخبرة: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child:
                                    Text("${profile.experienceYears} سنوات")),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Bio
                        // const Text(
                        //   "متخصص في قصات الشعر الكلاسيكية والحديثة\n+ حلاقة اللحية باحتراف",
                        //   style: TextStyle(fontSize: 14, height: 1.6),
                        // ),

                        const SizedBox(height: 20),

                        // التخصصات (الخدمات)
                        const Text("التخصص",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Column(
                          children: profile.services.map((service) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.content_cut,
                                      size: 18, color: Colors.black54),
                                  const SizedBox(width: 10),
                                  Text(service.nameAr,
                                      style: const TextStyle(fontSize: 14)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        // زر تحديث
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.grey.shade200,
                        //     elevation: 0,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8)),
                        //   ),
                        //   onPressed: () {},
                        //   child: const Text("تحديث المواعيد",
                        //       style:
                        //           TextStyle(color: Colors.black, fontSize: 14)),
                        // ),

                        const SizedBox(height: 20),

                        const Text("جدول العمل",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Column(
                          children:
                              List.generate(profile.workDays.length, (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(profile.workDays[index],
                                      style: const TextStyle(fontSize: 14)),
                                  Text(
                                    profile.workHours.length > index
                                        ? profile.workHours[index]
                                        : "",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  MyCustomButton(
                    text: localization.login_out,
                    backgroundColor: Colors.black,
                    voidCallback: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('access_token');
                      await prefs.remove('user_type');

                      await prefs.remove('fcm_token');
                      await prefs.remove('user_id');

                      await FirebaseMessaging.instance.deleteToken();

                      if (context.mounted) {
                        context.go('/LoginScreenView');
                      }
                    },
                  ),
                ],
              ),
            );
          } else if (state is SpecialistFailure) {
            return Center(
              child: Text(
                "خطأ: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
