import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  // Phase 1: Circle expansion (white screen -> black circle grows to fill screen)
  late AnimationController _circleController;
  late Animation<double> _circleAnimation;

  // Phase 2: Diagonal split (fully black -> diagonal white appears)
  late AnimationController _splitController;
  late Animation<double> _splitAnimation;

  // Phase 3: White expansion (white grows to fill screen)
  late AnimationController _whiteExpandController;
  late Animation<double> _whiteExpandAnimation;

  // Phase 4: Logo from top + Scissors from bottom meet in center (side by side)
  late AnimationController _logoScissorsController;
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _scissorsSlideAnimation;
  late Animation<double> _fadeInAnimation;

  int _currentPhase = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Phase 1: Circle grows from center — 900ms
    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _circleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _circleController, curve: Curves.easeInOut),
    );
    _circleController.addListener(() => setState(() {}));

    // Phase 2: Diagonal split — 700ms
    _splitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _splitAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _splitController, curve: Curves.easeInOut),
    );
    _splitController.addListener(() => setState(() {}));

    // Phase 3: White expansion — 700ms
    _whiteExpandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _whiteExpandAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _whiteExpandController, curve: Curves.easeInOut),
    );
    _whiteExpandController.addListener(() => setState(() {}));

    // Phase 4: Logo & Scissors slide in — 900ms
    _logoScissorsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    // Logo slides from top (negative Y = above center)
    _logoSlideAnimation = Tween<double>(begin: -1.0, end: 0).animate(
      CurvedAnimation(
        parent: _logoScissorsController,
        curve: Curves.easeOutCubic,
      ),
    );
    // Scissors slides from bottom (positive Y = below center)
    _scissorsSlideAnimation = Tween<double>(begin: 1.0, end: 0).animate(
      CurvedAnimation(
        parent: _logoScissorsController,
        curve: Curves.easeOutCubic,
      ),
    );
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoScissorsController,
        curve: const Interval(0, 0.4, curve: Curves.easeIn),
      ),
    );
    _logoScissorsController.addListener(() => setState(() {}));
  }

  Future<void> _startAnimationSequence() async {
    // Short pause on white screen
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    // Phase 1: Black circle expands from center
    setState(() => _currentPhase = 1);
    await _circleController.forward();
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Phase 2: Diagonal split appears
    setState(() => _currentPhase = 2);
    await _splitController.forward();
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Phase 3: White part expands to fill the screen
    setState(() => _currentPhase = 3);
    await _whiteExpandController.forward();
    if (!mounted) return;

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    // Phase 4: Logo from top + Scissors from bottom
    setState(() => _currentPhase = 4);
    await _logoScissorsController.forward();
    if (!mounted) return;

    // Hold the final frame
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    final type = prefs.getString('user_type');
    final seenOnBoarding = prefs.getBool('seenOnBoarding') ?? false;

    if (mounted) {
      if (token != null && type != null) {
        if (type == "user") {
          context.go('/NavBarView');
        } else {
          context.go('/SpecialistNavBarView');
        }
      } else if (seenOnBoarding) {
        context.go('/LoginScreenView');
      } else {
        context.go('/OnBoardingView');
      }
    }
  }

  @override
  void dispose() {
    _circleController.dispose();
    _splitController.dispose();
    _whiteExpandController.dispose();
    _logoScissorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // White base
        Container(color: Colors.white),

        // Phase 1: Black circle expanding from center (using CustomPaint to fill screen)
        if (_currentPhase == 1)
          SizedBox.expand(
            child: CustomPaint(
              painter: _CircleExpansionPainter(
                progress: _circleAnimation.value,
              ),
            ),
          ),

        // Phase 2: Diagonal split
        if (_currentPhase == 2)
          SizedBox.expand(
            child: CustomPaint(
              painter: _DiagonalSplitPainter(
                progress: _splitAnimation.value,
              ),
            ),
          ),

        // Phase 3: White expanding over the diagonal
        if (_currentPhase == 3)
          SizedBox.expand(
            child: CustomPaint(
              painter: _WhiteExpansionPainter(
                progress: _whiteExpandAnimation.value,
              ),
            ),
          ),

        // Phase 4: White screen with Logo + Scissors side by side in center
        if (_currentPhase >= 4) _buildLogoAndScissors(size),
      ],
    );
  }

  /// Phase 4: Logo slides from top, Scissors slide from bottom
  /// They meet in center side by side (Row layout):
  ///   [ Scissors (from bottom) ] [ Logo "الكشخة" (from top) ]
  Widget _buildLogoAndScissors(Size size) {
    final screenWidth = size.width > 600 ? size.width * .75 : size.width;

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Scissors — comes from BOTTOM to center
            Transform.translate(
              offset: Offset(
                0,
                _scissorsSlideAnimation.value * size.height * 0.5,
              ),
              child: Opacity(
                opacity: _fadeInAnimation.value,
                child: Image.asset(
                  'assets/images/shiny-scissors.png',
                  width: screenWidth * 0.12,
                  // height: 80,
                  // fit: BoxFit.contain,
                ),
              ),
            ),
            // const SizedBox(width: 10),
            // Logo "الكشخة" — comes from TOP to center
            Transform.translate(
              offset: Offset(
                0,
                _logoSlideAnimation.value * size.height * 0.5,
              ),
              child: Opacity(
                opacity: _fadeInAnimation.value,
                child: Image.asset(
                  'assets/images/الكشخة_page-0001 1.png',
                  width: screenWidth * 0.25,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Phase 1: Draws a black circle expanding from the center of the screen.
/// Uses CustomPaint so the circle can freely grow beyond screen bounds
/// and properly fill the entire screen.
class _CircleExpansionPainter extends CustomPainter {
  final double progress;

  _CircleExpansionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // maxRadius = distance from center to the farthest corner
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = sqrt(centerX * centerX + centerY * centerY);

    final currentRadius = progress * maxRadius;

    final paint = Paint()..color = const Color(0xff151414);
    canvas.drawCircle(Offset(centerX, centerY), currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _CircleExpansionPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Phase 2: Draws a diagonal split — starts fully black, then a white triangle
/// grows from the right side. The diagonal goes from bottom-left to top-right
/// matching the Figma reference image.
class _DiagonalSplitPainter extends CustomPainter {
  final double progress;

  _DiagonalSplitPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = const Color(0xff151414);
    final whitePaint = Paint()..color = Colors.white;

    // Full black background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), blackPaint);

    // White triangle grows from top-right corner diagonally.
    // At progress=0: no white visible
    // At progress=1: full diagonal — white is the upper-right half
    //   (triangle: top-right -> bottom-right -> top-left)
    //
    // The diagonal line at full progress goes from (0, height) to (width, 0)

    // Interpolate: the white triangle's two moving vertices
    // Vertex 1: moves along the top edge from (width, 0) to (0, 0)
    final topEdgeX = lerpDouble(size.width, 0, progress)!;
    // Vertex 2: moves along the right edge from (width, 0) to (width, height)
    final rightEdgeY = lerpDouble(0, size.height, progress)!;

    final whitePath = Path();
    whitePath.moveTo(size.width, 0); // top-right corner (anchor)
    whitePath.lineTo(topEdgeX, 0); // moves left along top edge
    whitePath.lineTo(size.width, rightEdgeY); // moves down along right edge
    whitePath.close();

    canvas.drawPath(whitePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant _DiagonalSplitPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Phase 3: The white area (which was a diagonal half) expands to fill the
/// entire screen. The black triangle shrinks toward bottom-left and disappears.
class _WhiteExpansionPainter extends CustomPainter {
  final double progress;

  _WhiteExpansionPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()..color = Colors.white;
    final blackPaint = Paint()..color = const Color(0xff151414);

    // Fill white first
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), whitePaint);

    // Black triangle shrinks toward bottom-left corner.
    // At progress=0: black is the lower-left half
    //   (triangle: (0,0) -> (0, height) -> (width, height))
    // At progress=1: black triangle collapses to nothing
    //
    // Two moving vertices:
    // Top vertex: (0, 0) -> moves down to (0, height)
    // Right vertex: (width, height) -> moves left to (0, height)
    // The bottom-left corner (0, height) stays fixed as the collapse point.

    final topY = lerpDouble(0, size.height, progress)!;
    final rightX = lerpDouble(size.width, 0, progress)!;

    final blackPath = Path();
    blackPath.moveTo(0, topY); // top vertex slides down
    blackPath.lineTo(0, size.height); // bottom-left corner (fixed)
    blackPath.lineTo(rightX, size.height); // right vertex slides left
    blackPath.close();

    canvas.drawPath(blackPath, blackPaint);
  }

  @override
  bool shouldRepaint(covariant _WhiteExpansionPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
