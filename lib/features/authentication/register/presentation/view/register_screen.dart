import 'package:elkashkha/features/authentication/register/presentation/view/widgets/register_screen_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import '../../../../../core/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title:  Text(AppLocalizations.of(context)!.register),
            titleTextStyle: const TextStyle(color: AppTheme.white, fontSize: 20),
            centerTitle: true,
          ),

          backgroundColor: AppTheme.primary,
          body: const RegisterScreenBody(),
        ),
      ),
    );
  }
}
