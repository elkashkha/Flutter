import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_profile__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialistCubit()..fetchProfile(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          title: Text(
            'معرض الأعمال',
            style: GoogleFonts.notoNaskhArabic(
              color: AppTheme.primary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: BlocBuilder<SpecialistCubit, SpecialistState>(
          builder: (context, state) {
            if (state is SpecialistLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary));
            } else if (state is SpecialistLoaded) {
              final portfolioList = state.profile.portfolio;
              if (portfolioList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.image_not_supported,
                          size: 80, color: AppTheme.gray),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد أعمال حتى الآن',
                        style: GoogleFonts.notoNaskhArabic(
                          color: AppTheme.primary,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(
                    16.0), // Added padding for better spacing
                itemCount: portfolioList.length,
                itemBuilder: (context, index) {
                  final item = portfolioList[index];
                  return Card(
                    color: AppTheme.white,
                    margin: const EdgeInsets.only(
                        bottom: 16), // Spacing between cards
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16), // Softer corners
                    ),
                    elevation: 4, // Slightly higher elevation for depth
                    child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Increased internal padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.service.nameAr,
                            style: GoogleFonts.notoNaskhArabic(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('قبل',
                                        style: GoogleFonts.notoNaskhArabic(
                                          color: AppTheme.gray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      // Added rounded corners to images
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.beforeImage != null
                                          ? Image.network(
                                              item.beforeImage!,
                                              height: 140,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 140,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                      child: Icon(Icons.error,
                                                          color: Colors.red)),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 140,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Text('لا توجد صورة'),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('بعد',
                                        style: GoogleFonts.notoNaskhArabic(
                                          color: AppTheme.gray,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      // Added rounded corners to images
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.afterImage != null
                                          ? Image.network(
                                              item.afterImage!,
                                              height: 140,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Container(
                                                  height: 140,
                                                  color: Colors.grey[300],
                                                  child: const Center(
                                                      child: Icon(Icons.error,
                                                          color: Colors.red)),
                                                );
                                              },
                                            )
                                          : Container(
                                              height: 140,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: Text('لا توجد صورة'),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.descriptionAr,
                            style: GoogleFonts.notoNaskhArabic(
                              color: AppTheme.primary.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is SpecialistFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.error,
                      style: GoogleFonts.notoNaskhArabic(
                          color: AppTheme.primary, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
