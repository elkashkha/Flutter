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
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, int>(
        builder: (context, state) {
          var cubit = OnBoardingCubit.get(context);
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

          return Scaffold(
            body: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) => cubit.changePage(index),
                      itemCount: cubit.pages.length,
                      itemBuilder: (context, index) {
                        final page = cubit.pages[index];

                        var title = AppLocalizations.of(context)!.title1;
                        var description = AppLocalizations.of(context)!.desc1;

                        if (index == 1) {
                          title = AppLocalizations.of(context)!.title2;
                          description = AppLocalizations.of(context)!.desc2;
                        } else if (index == 2) {
                          title = AppLocalizations.of(context)!.title3;
                          description = AppLocalizations.of(context)!.desc3;
                        }

                        return Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.62,
                              child: SvgPicture.asset(
                                page.image,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: Column(
                                children: [
                                  Text(title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoNaskhArabic(
                                          fontSize: screenWidth * 0.045)),
                                  SizedBox(height: screenHeight * 0.015),
                                  Text(description,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoNaskhArabic(
                                          fontSize: screenWidth * 0.034,
                                          color: Colors.black54,
                                          height: 1.5)),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: cubit.pages.length,
                    effect: ExpandingDotsEffect(
                        activeDotColor: AppTheme.primary,
                        dotColor: Colors.grey,
                        dotHeight: screenWidth * 0.015,
                        dotWidth: screenWidth * 0.015),
                    textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: screenHeight * 0.04, horizontal: screenWidth * 0.1),
                    child: Column(
                      children: [
                        if (state == cubit.pages.length - 1)
                          ElevatedButton(
                            onPressed: () async {
                              await setOnBoardingSeen();
                              context.push('/LoginScreenView');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(isArabic ? 'ابدأ الآن' : 'Start Now',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    color: AppTheme.white)),
                          )
                        else
                          ElevatedButton(
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(isArabic ? 'التالي' : 'Next',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    color: AppTheme.white)),
                          ),
                        SizedBox(height: screenHeight * 0.02),
                        OutlinedButton(
                          onPressed: () async {
                            await setOnBoardingSeen();
                            context.push('/NavBarView');
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppTheme.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(color: Colors.black),
                          ),
                          child: Text(isArabic ? 'الدخول كزائر' : 'Continue as Guest',
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
