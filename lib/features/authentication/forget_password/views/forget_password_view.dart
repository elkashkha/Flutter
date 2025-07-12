import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forget_password.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ForgetPasswordBody(),
      ),
    );
  }
}
