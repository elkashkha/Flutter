  import 'package:elkashkha/features/authentication/login/presentation/view/widgets/login_screen_body.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter_gen/gen_l10n/app_localizations.dart';
  
  import 'package:flutter/material.dart';
  import '../../../../../core/app_theme.dart';
  
  class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});
  
    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title:  Text(AppLocalizations.of(context)!.login),
            titleTextStyle: const TextStyle(color: AppTheme.white, fontSize: 20),
            centerTitle: true,
          ),
          backgroundColor: AppTheme.primary,
          body: const LoginScreenBody(),
        ),
      );
    }
  }
