import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../core/app_theme.dart';
import 'gift_list.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rawExtra = GoRouterState.of(context).extra;
    final Map<String, dynamic> extra =
        rawExtra is Map ? Map<String, dynamic>.from(rawExtra) : {};

    final String accountType = extra['accountType'] ?? 'Unknown';
    final int points = extra['points'] ?? 0;

    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          locale.gifts,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 343,
              height: 120,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xffFAF8EF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/10459c28c3b6b59bab6e18d49269f69985c24c31.png',
                    width: 65,
                    height: 65,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              accountType,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  locale.points,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffB0AEAE),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$points',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 200,
                          child: LinearProgressIndicator(
                            value: points / 1000,
                            backgroundColor: const Color(0xffE0E0E0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFFFD700)),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Gifts Section
            const SizedBox(height: 20),
            const GiftsListScreen()
          ],
        ),
      ),
    );
  }
}
