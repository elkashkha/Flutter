import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/home_screen_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff0B0B0F) : Theme.of(context).scaffoldBackgroundColor,
        body: const HomeScreenViewBody(),
      ),
    );
  }
}
