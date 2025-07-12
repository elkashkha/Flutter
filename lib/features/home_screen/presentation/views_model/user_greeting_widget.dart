import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../profile_screen/presentation/view_model/user_cubit.dart';
import '../../../profile_screen/presentation/view_model/user_state.dart';

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Text(
            "${localization.hello}, ${state.user.name}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (state is UserFailure) {
          return const Text("حدث خطأ أثناء تحميل الاسم");
        }
        return const Text("جاري التحميل...");
      },
    );
  }
}
