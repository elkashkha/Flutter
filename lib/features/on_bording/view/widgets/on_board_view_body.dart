import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../core/app_theme.dart';
import '../../view_model/on_board_cubit.dart';

class OnBoardViewBody extends StatefulWidget {
  const OnBoardViewBody({super.key});

  @override
  State<OnBoardViewBody> createState() => _OnBoardViewBodyState();
}

class _OnBoardViewBodyState extends State<OnBoardViewBody> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  Future<void> setOnBoardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnBoarding', true);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, int>(
        builder: (context, state) {
          var cubit = OnBoardingCubit.get(context);
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

          return Scaffold(
            body: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFC4C4C4), // Light gray at top
                      Color(0xFF151414), // Dark/black at bottom
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    // --- Top: PageView with SVG images ---
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) => cubit.changePage(index),
                        itemCount: cubit.pages.length,
                        itemBuilder: (context, index) {
                          final page = cubit.pages[index];
                          return Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.08),
                            child: SvgPicture.asset(
                              page.image,
                              width: double.infinity,
                              fit: BoxFit.contain,
                            ),
                          );
                        },
                      ),
                    ),

                    // --- Bottom section: dark area with text, indicators, buttons ---
                    _buildBottomSection(
                      context,
                      state,
                      cubit,
                      isArabic,
                      screenWidth,
                      screenHeight,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    int state,
    OnBoardingCubit cubit,
    bool isArabic,
    double screenWidth,
    double screenHeight,
  ) {
    // Get localized text for current page
    var title = AppLocalizations.of(context)!.title1;
    var description = AppLocalizations.of(context)!.desc1;

    if (state == 1) {
      title = AppLocalizations.of(context)!.title2;
      description = AppLocalizations.of(context)!.desc2;
    } else if (state == 2) {
      title = AppLocalizations.of(context)!.title3;
      description = AppLocalizations.of(context)!.desc3;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicators at the top of bottom section
          SmoothPageIndicator(
            controller: pageController,
            count: cubit.pages.length,
            effect:  const ExpandingDotsEffect(
              activeDotColor: AppTheme.primary,
              dotColor: Colors.white,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 3,
              spacing: 6,
            ),
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          ),
          SizedBox(height: screenHeight * 0.025),

          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: screenHeight * 0.012),

          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoNaskhArabic(
              fontSize: screenWidth * 0.034,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Buttons row: "التالي" button + "تخطي!" text
          Row(
            children: [
              // "التالي" / "ابدأ الآن" button
              SizedBox(
                width: 115,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    if (state == cubit.pages.length - 1) {
                      await setOnBoardingSeen();
                      if (mounted) context.go('/LoginScreenView');
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFF151414),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    state == cubit.pages.length - 1
                        ? (isArabic ? 'ابدأ الآن' : 'Start Now')
                        : (isArabic ? 'التالي' : 'Next'),
                    style: GoogleFonts.notoNaskhArabic(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color:  Colors.white,
                    ),
                  ),
                ),
              ),
const Spacer()        ,      // "تخطي!" text button
              GestureDetector(
                onTap: () async {
                  await setOnBoardingSeen();
                  if (mounted) context.go('/LoginScreenView');
                },
                child: Text(
                  isArabic ? 'تخطي!' : 'Skip!',
                  style: GoogleFonts.notoNaskhArabic(
                    fontSize: screenWidth * 0.038,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
