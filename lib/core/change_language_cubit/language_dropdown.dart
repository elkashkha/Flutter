import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/app_theme.dart';
import 'change_language_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return Column(
          children: [
            ListTile(
              leading: DropdownButton<String>(
                value: state.languageCode,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    context.read<LanguageCubit>().changeLanguage(newValue);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text('العربية'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
              ),
              title: Align(
                alignment: Localizations.localeOf(context).languageCode == 'ar'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  localization.language,
                  style: const TextStyle(fontSize: 16, color: AppTheme.gray),
                ),
              ),
              trailing: const Icon(Icons.language, color: AppTheme.primary),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }
}