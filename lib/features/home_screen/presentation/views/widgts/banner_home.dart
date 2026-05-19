import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_list.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/cubit/top_rate_cubit.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/cubit/top_rate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBannerWidget extends StatelessWidget {
  const HomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => TopRatedSpecialistCubit()..getTopRatedSpecialist(),
      child: BlocBuilder<TopRatedSpecialistCubit, TopRatedSpecialistState>(
        builder: (context, state) {
          if (state is TopRatedSpecialistLoading) {
            return const ShimmerGridServiceLoader();

          } else if (state is TopRatedSpecialistSuccess) {
            final specialist = state.specialist;

            if (specialist.name == "No specialists found this month") {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                // Title at the top
                Text(
                  isArabic ? "تعرف على موظف الشهر المثالي" : "Employee of the Month",
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                    decoration: TextDecoration.underline,
                    decorationColor: isDark ? Colors.white : Colors.black,
                    decorationThickness: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Card
                Container(
                  width: 300,
                  height: 116,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111), // Very dark background
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        // Decorative Background Circles
                        Positioned(
                          bottom: -50,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: List.generate(3, (index) => Container(
                                width: 140.0 + (index * 40),
                                height: 140.0 + (index * 40),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                                ),
                              )),
                            ),
                          ),
                        ),
                        // Specialist Image
                        Positioned.fill(
                          child: CachedNetworkImage(

                            imageUrl: specialist.profilePicture,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                            errorWidget: (_, __, ___) => const Icon(Icons.person, size: 80, color: Colors.white54),
                          ),
                        ),
                        // Name Overlay at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.8),
                                  Colors.black.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                            child: Text(
                              specialist.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.tajawal(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is TopRatedSpecialistFailure) {
            if (state.message.toString().contains("No specialists found this month") ||
                state.message.toString().contains("404")) {
              return const SizedBox.shrink();
            }
            return const SizedBox.shrink(); // Hide on error
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
