import 'package:elkashkha/features/profile_screen/presentation/view/widgets/profile_screen_body.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 70.0),
      child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
        body: ProfileScreenBody(),
      )),
    );
  }
}
