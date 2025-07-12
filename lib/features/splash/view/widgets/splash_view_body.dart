import 'dart:ui';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin { // تغيير من SingleTickerProviderStateMixin إلى TickerProviderStateMixin
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late AnimationController bounceController;
  late Animation<double> bounceAnimation;

  @override
  void initState() {
    super.initState();
    initFadeAnimation();
    initBounceAnimation();
    navigateToNextScreen();
  }

  @override
  void dispose() {
    fadeController.dispose();
    bounceController.dispose();
    super.dispose();
  }

  void initFadeAnimation() {
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: fadeController, curve: Curves.easeInOut),
    );
    slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 1), () {
      fadeController.forward();
    });
  }

  void initBounceAnimation() {
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    bounceAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: bounceController, curve: Curves.bounceOut),
    );
    bounceController.repeat(reverse: true);
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final seenOnBoarding = prefs.getBool('seenOnBoarding') ?? false;

    if (mounted) {
      if (token != null) {
        context.go('/NavBarView');
      }
      else if (seenOnBoarding) {
        context.go('/LoginScreenView');
        // context.go('/NavBarView');
      } else {
        context.go('/OnBoardingView');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: bounceAnimation,
                child: Image.asset(
                  'assets/images/cut.gif',
                  width: screenWidth * 0.2,
                  height: 150,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: fadeController, curve: Curves.easeInOut)),
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Image.asset(
                'assets/images/الكشخة_page-0001 1.png',
              width: screenWidth * 0.4,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}