import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../booking_tab/view_model/cubit/cubit/cubit/portfolio_cubit.dart';
import '../../../booking_tab/view_model/cubit/cubit/cubit/portfolio_state.dart';
import '../../view_model/specialist_model.dart';
import '../../view_model/specialist_profile__cubit.dart';
import '../../view_model/specialist_profile__state.dart';

class ProfileSpecialist extends StatelessWidget {
  const ProfileSpecialist({super.key});

  @override
  @override
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            decoration: TextDecoration.underline,
            decorationColor: Colors.black,
            decorationThickness: 1.5,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    final specialistCubit = context.read<SpecialistCubit>();
    if (specialistCubit.state is SpecialistInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        specialistCubit.fetchProfile();
      });
    }

    return BlocBuilder<SpecialistCubit, SpecialistState>(
      builder: (context, state) {
        if (state is SpecialistLoading) {
          return const Center(
            child: CustomDotsTriangleLoader(),
          );
        } else if (state is SpecialistLoaded) {
          final SpecialistProfile profile = state.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ====== Custom Top App Bar ======
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "الملف الشخصي",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.black),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: profile.profilePicture != null
                              ? NetworkImage(profile.profilePicture!)
                              : null,
                          child: profile.profilePicture == null
                              ? const Icon(Icons.person, size: 16, color: Colors.grey)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ====== Black Profile Card ======
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xff0B0B0F), // Black background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name, Stars and Avatar on the right (first in RTL)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: profile.profilePicture != null
                                ? NetworkImage(profile.profilePicture!)
                                : null,
                            child: profile.profilePicture == null
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              buildStars(profile.overallRating),
                            ],
                          ),
                        ],
                      ),
                      // Edit Icon on the left (second in RTL)
                      GestureDetector(
                        onTap: () {
                          context.push('/UpdateProfileScreen');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ====== Personal Info Section ======
                _buildSectionTitle("البيانات الشخصية"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffE2E2E6), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.push('/UpdateProfileScreen');
                          },
                          icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.black),
                          label: const Text(
                            "تعديل البيانات الشخصية",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xffE2E2E6)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ====== Experience & Bio ======
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "خبرة ${profile.experienceYears} سنوات",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_outlined,
                          color: Colors.black,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // const Text(
                    //   "متخصص في قصات الشعر الكلاسيكية والحديثة + حلاقة اللحية باحتراف",
                    //   textAlign: TextAlign.center,
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.black,
                    //     height: 1.5,
                    //   ),
                    // ),
                  ],
                ),

                // ====== Statistics ======
                _buildSectionTitle("الاحصايات"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffE2E2E6), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'التقييم حسب الادارة:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          buildStars(profile.adminRatingsAvg),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.black54, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "المنتجات الشهرية:",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const Spacer(),
                          Text(
                            "${profile.monthlyProducts}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.add_box_outlined, color: Colors.black54, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "عدد الخدمات الإضافية الشهرية:",
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          const Spacer(),
                          Text(
                            "${profile.monthlyExtras}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                MyCustomButton(
                  text: "إضافة المنتجات والخدمات الإضافية",
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  voidCallback: () {
                    _showAddNumbersDialog(context);
                  },
                ),

                // ====== Specialties ======
                _buildSectionTitle("التخصص"),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: profile.services.map((service) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xffE2E2E6), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.content_cut, size: 14, color: Colors.black54),
                          const SizedBox(width: 6),
                          Text(
                            service.nameAr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                // ====== Work Schedule ======
                _buildSectionTitle("جدول العمل"),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xffE2E2E6), width: 1),
                  ),
                  child: Column(
                    children: [
                      ...List.generate(profile.workDays.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                profile.workDays[index],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile.workHours.length > index
                                    ? profile.workHours[index]
                                    : "",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ====== Logout Button ======
                MyCustomButton(
                  text: localization.login_out,
                  backgroundColor: Colors.red.shade800,
                  textColor: Colors.white,
                  voidCallback: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('access_token');
                    await prefs.remove('user_type');
                    await prefs.remove('fcm_token');
                    await prefs.remove('user_id');

                    try {
                      await FirebaseMessaging.instance.deleteToken();
                    } catch (e) {
                      debugPrint('Failed to delete FCM token: $e');
                    }

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
    );
  }
  void _showAddNumbersDialog(BuildContext context) {
    int? productsSold;
    int? extraServicesUsed;
    String? nameAr;
    String? descAr;

    showDialog(
      context: context,
      builder: (ctx) {
        return BlocProvider(
          create: (_) => PortfolioCubit(),
          child: BlocConsumer<PortfolioCubit, PortfolioState>(
            listener: (context, state) {
              if (state is PortfolioSuccess) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("✅ تم تحديث البيانات بنجاح"),
                  ),
                );
              } else if (state is PortfolioError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return AlertDialog(
                title: const Text("إضافة بورتفوليو مخصص"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration:
                        const InputDecoration(labelText: "اسم العميل "),
                        onChanged: (v) => nameAr = v,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration:
                        const InputDecoration(labelText: "الوصف"),
                        onChanged: (v) => descAr = v,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: productsSold,
                        hint: const Text("عدد المنتجات المباعة"),
                        items: List.generate(30, (i) => i + 1)
                            .map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.toString()),
                        ))
                            .toList(),
                        onChanged: (v) => productsSold = v,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: extraServicesUsed,
                        hint: const Text("عدد الخدمات الإضافية"),
                        items: List.generate(30, (i) => i + 1)
                            .map((v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.toString()),
                        ))
                            .toList(),
                        onChanged: (v) => extraServicesUsed = v,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إلغاء"),
                  ),
                  MyCustomButton(
                    text: "حفظ",
                    isLoading: state is PortfolioLoading,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    voidCallback: () {
                      if (nameAr?.isNotEmpty == true ||
                          descAr?.isNotEmpty == true ||
                          productsSold != null ||
                          extraServicesUsed != null) {
                        context.read<PortfolioCubit>().addCustomPortfolio(
                          nameAr: nameAr,
                          descAr: descAr,
                          productsSold: productsSold,
                          extraServicesUsed: extraServicesUsed,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text("يرجى إدخال البيانات قبل الحفظ"),
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

}

Widget buildStars(double rating) {
  List<Widget> stars = [];

  int fullStars = rating.floor();
  bool hasHalfStar = (rating - fullStars) >= 0.5;

  for (int i = 0; i < fullStars; i++) {
    stars.add(const Icon(Icons.star, color: Colors.amber, size: 20));
  }

  if (hasHalfStar) {
    stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 20));
  }

  while (stars.length < 5) {
    stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 20));
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: stars,
  );
}
