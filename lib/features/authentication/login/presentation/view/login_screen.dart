  import 'package:elkashkha/features/authentication/login/presentation/view/widgets/login_screen_body.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  
  import 'package:flutter/material.dart';
  import '../../../../../core/app_theme.dart';
  
  class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});
  
    @override
    Widget build(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return SafeArea(
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : AppTheme.white,
          body: const LoginScreenBody(),
        ),
      );
    }
  }
