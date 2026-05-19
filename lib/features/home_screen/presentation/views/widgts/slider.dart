import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elkashkha/core/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading.dart';
import '../../views_model/slider/slider_cubit.dart';

class MyCarouselSlider extends StatefulWidget {
  const MyCarouselSlider({super.key});

  @override
  State<MyCarouselSlider> createState() => _MyCarouselSliderState();
}

class _MyCarouselSliderState extends State<MyCarouselSlider> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SliderCubit()..fetchSliders(),
      child: BlocBuilder<SliderCubit, SliderState>(
        builder: (context, state) {
          if (state is SliderLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is SliderError) {
            return Center(child: Text(state.message));
          } else if (state is SliderLoaded) {
            final sliders = state.sliderModel.data ?? [];
            if (sliders.isEmpty) {
              return const SizedBox.shrink();
            }

            final locale = Localizations.localeOf(context).languageCode;
            final isArabic = locale == 'ar';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Carousel Slider
                    CarouselSlider(
                      items: sliders.map((slider) {
                        return Stack(
                          children: [
                            // 1. Image Background
                            Positioned.fill(
                              child: CachedNetworkImage(
                                imageUrl: slider.image ?? 'assets/images/2.png',
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                    const Center(child: CustomDotsTriangleLoader()),
                                errorWidget: (context, url, error) =>
                                    const Center(child: Icon(Icons.error, color: Colors.red, size: 50)),
                              ),
                            ),

                            // 2. Dark Gradient Overlay (Smooth integration)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.85),
                                      Colors.black.withOpacity(0.1),
                                    ],
                                    begin: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                    end: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ),

                            // 3. Text and Button Content
                            Positioned(
                              right: isArabic ? 24 : null,
                              left: isArabic ? null : 24,
                              top: 0,
                              bottom: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slider.title?[isArabic ? 'ar' : 'en'] ?? 'العناية التي تستحقها... في أجواء\nراقية',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        height: 1.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    if (slider.subtitle != null && slider.subtitle![isArabic ? 'ar' : 'en'] != null) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        slider.subtitle![isArabic ? 'ar' : 'en']!,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: () {
                                        context.push('/ServicesScreen');
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: const BorderSide(color: Colors.white, width: 1.2),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: Text(
                                        isArabic ? 'خدماتنا' : 'Our Services',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 160.0,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),

                    // 4. Custom Vertical Dots Indicator (Fixed in place on top of CarouselSlider)
                    Positioned(
                      left: isArabic ? 16 : null,
                      right: isArabic ? null : 16,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(sliders.length, (dotIndex) {
                          final isActive = _currentIndex == dotIndex;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            width: 8,
                            height: isActive ? 24 : 8,
                            decoration: BoxDecoration(
                              color: isActive ? Colors.white : Colors.transparent,
                              border: Border.all(color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('لا توجد بيانات حالياً'));
        },
      ),
    );
  }
}