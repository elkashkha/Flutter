import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/app_theme.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';
import '../view_model/privacy__cubit.dart';
import '../view_model/privacy__state.dart';

class PoliciesView extends StatelessWidget {
  const PoliciesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => PoliciesCubit()..fetchPolicies(),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? const Color(0xff151414) : AppTheme.white,
          title: CustomAppBar(
            title:  _getLocalizedText(context, 'privacy_policy'),

          ),
        ),
        body: BlocBuilder<PoliciesCubit, PoliciesState>(
          builder: (context, state) {
            if (state is PoliciesLoading) {
              return Center(child: CircularProgressIndicator(color: isDark ? Colors.white : Colors.black));
            } else if (state is PoliciesLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.policies.length,
                itemBuilder: (context, index) {
                  final policy = state.policies[index];
                  final locale = Localizations.localeOf(context).languageCode;

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy.title[locale] ?? 'No title',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          policy.content[locale] ?? 'No content available.',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is PoliciesError) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  String _getLocalizedText(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    final translations = {
      'privacy_policy': {
        'ar': 'سياسة الخصوصية',
        'en': 'Privacy Policy',
      },
    };
    return translations[key]?[locale] ?? key;
  }
}
