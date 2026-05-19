import 'package:elkashkha/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gift_list.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rawExtra = GoRouterState.of(context).extra;
    final Map<String, dynamic> extra =
        rawExtra is Map ? Map<String, dynamic>.from(rawExtra) : {};

    final String accountType = extra['accountType'] ?? 'عادي';
    final int points = extra['points'] ?? 0;

    final locale = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isGold = accountType == 'ذهبي';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : AppTheme.primary, // Dark background for the top section
      body: SafeArea(
        bottom: false, // Let the white container reach the bottom
        child: Column(
          children: [
            // 1. Dark Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // App Bar Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          isArabic ? Icons.arrow_back : Icons.arrow_forward,
                          color: Colors.white,
                          size: 26,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        isArabic ? 'النقاط' : 'Points',
                        style: GoogleFonts.tajawal(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacing to center the title
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Golden Trophy Image
                  Image.asset(
                    'assets/images/10459c28c3b6b59bab6e18d49269f69985c24c31.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            // 2. White Curved Container Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xff151414) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Tier Header Bar
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isGold 
                                ? (isDark ? const Color(0xFF332A15) : const Color(0xFFFEF9E7)) 
                                : (isDark ? const Color(0xFF222121) : const Color(0xFFF2F4F4)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            accountType,
                            style: GoogleFonts.tajawal(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isGold ? const Color(0xFFF5B041) : (isDark ? Colors.white70 : Colors.grey.shade700),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Available points box
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF222121) : const Color(0xFFF2F4F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isArabic
                                ? 'عدد النقاط المتوفرة لديك: $points'
                                : 'Available points: $points',
                            style: GoogleFonts.tajawal(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Gift Item List View (Dynamic from API via BLoC)
                        const GiftsListScreen(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
