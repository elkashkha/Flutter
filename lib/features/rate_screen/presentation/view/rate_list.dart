import 'package:elkashkha/features/rate_screen/presentation/view/widgtes/rate_list_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class RateList extends StatelessWidget {
  const RateList({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      appBar: CustomAppBar(
        title: localization.customer_reviews,
      ),
      body: const ReviewsScreen(),
    );
  }
}
