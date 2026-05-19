import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SpecialistsSection extends StatelessWidget {
  final List<dynamic> specialists;
  final String? selectedTeamId;
  final Function(String id, String name, String? overprice) onSpecialistSelected;

  const SpecialistsSection({
    super.key,
    required this.specialists,
    required this.selectedTeamId,
    required this.onSpecialistSelected,
  });

  @override
  Widget build(BuildContext context) {
    var localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String? selectedOverprice;
    try {
      if (selectedTeamId != null) {
        selectedOverprice = specialists
            .firstWhere((s) => s.id.toString() == selectedTeamId)
            .overprice;
      }
    } catch (_) {}

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.choose_the_team,
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 150, // Increased height for card + icon
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specialists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final specialist = specialists[index];
              final isSelected = selectedTeamId == specialist.id.toString();

              return GestureDetector(
                onTap: () {
                  onSpecialistSelected(
                    specialist.id.toString(),
                    specialist.name,
                    specialist.overprice,
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected 
                              ? (isDark ? Colors.white : Colors.black) 
                              : (isDark ? Colors.grey.shade800 : Colors.transparent),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              specialist.profilePicture ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, size: 40, color: Colors.grey),
                            ),
                            // Gradient overlay for text readability
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              height: 40,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              left: 4,
                              right: 4,
                              child: Text(
                                specialist.name ?? '',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(
                      isSelected ? Icons.check_circle : Icons.add_circle_outline,
                      color: isSelected 
                          ? (isDark ? Colors.white : Colors.black) 
                          : (isDark ? Colors.white38 : Colors.grey.shade600),
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (selectedOverprice != null &&
            selectedOverprice.isNotEmpty &&
            selectedOverprice != "0" &&
            selectedOverprice != "0.00")
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: localizations.specialist_fee(selectedOverprice),
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: " "),
                TextSpan(
                  text: selectedTeamId != null
                      ? specialists
                          .firstWhere((s) => s.id.toString() == selectedTeamId)
                          .level
                      : "",
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
