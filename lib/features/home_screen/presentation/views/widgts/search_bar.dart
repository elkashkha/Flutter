import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SearchField extends StatelessWidget {
  const SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () {
        context.push('/SearchScreen');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF151414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF292828)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                 localization.search_now,

                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
