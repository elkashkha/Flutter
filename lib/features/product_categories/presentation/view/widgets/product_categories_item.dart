import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductCategoriesItem extends StatelessWidget {
  final int categoryId;
  final String title;

  const ProductCategoriesItem({
    super.key,
    required this.categoryId,
    required this.title,
  });

  bool _isHairCategory(String text) {
    final lower = text.toLowerCase();
    return lower.contains('شعر') || lower.contains('hair');
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = _isHairCategory(title)
        ? 'assets/product/shampoo-bottle(1)1.svg'
        : 'assets/product/serum1.svg';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/ProductList', extra: {'categoryId': categoryId});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 60,
              height: 60,
              colorFilter: ColorFilter.mode(isDark ? Colors.white70 : Colors.black87, BlendMode.srcIn),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
