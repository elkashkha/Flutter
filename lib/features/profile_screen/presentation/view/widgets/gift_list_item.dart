import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GiftListItem extends StatelessWidget {
  final String imageUrl;
  final String titleAr;
  final String titleEn;
  final bool canClaim;
  final VoidCallback onClaimPressed;

  const GiftListItem({
    Key? key,
    required this.imageUrl,
    required this.titleAr,
    required this.titleEn,
    required this.canClaim,
    required this.onClaimPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final title = locale.languageCode == 'ar' ? titleAr : titleEn;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          width: 343,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.gray),
          ),
          child: Row(
            children: [
              Image.network(
                imageUrl,
                width: 113,
                height: 69,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.giftTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Tooltip(
          message: canClaim ? '' : 'ليس لديك نقاط كافية لاستلام الهدية.',
          child: MyCustomButton(
            text: l10n.claimGiftButton,
            backgroundColor: canClaim ? null : Colors.grey.shade300,
            voidCallback: canClaim
                ? onClaimPressed
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ليس لديك نقاط كافية لاستلام الهدية.'),
                      ),
                    );
                  },
          ),
        ),
      ],
    );
  }
}
