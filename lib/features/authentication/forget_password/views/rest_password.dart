import 'package:elkashkha/features/authentication/forget_password/views/rest_password_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestPassword extends StatelessWidget {
  const RestPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: ResetPasswordBody(),
      ),
    );
  }
}
