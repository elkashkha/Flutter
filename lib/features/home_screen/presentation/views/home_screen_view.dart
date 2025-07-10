import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/home_screen_view_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.white,
        body: HomeScreenViewBody(),
      ),
    );
  }
}
