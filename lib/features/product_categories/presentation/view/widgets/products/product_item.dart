import 'package:cached_network_image/cached_network_image.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:math';
import '../../../../../../core/widgets/loading.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final Product product;

  final double price;
  final double originalPrice;
  final double rating;

  const ProductItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.product,
  });

  bool _isNewProduct(String createdAt) {
    if (createdAt.isEmpty) return false;
    try {
      final createdDate = DateTime.parse(createdAt);
      final difference = DateTime.now().difference(createdDate);
      return difference.inDays <= 30; // Mark as new if added within the last 30 days
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final isNew = _isNewProduct(product.createdAt);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        context.push('/ProductDetails', extra: {'product': product});
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Price Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      height: 170,
                      child: Center(child: CustomDotsTriangleLoader()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 170,
                      color: isDark ? const Color(0xFF333333) : Colors.grey[200],
                      child: const Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                
                if (isNew)
                  PositionedDirectional(
                    top: 0,
                    start: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadiusDirectional.only(
                          topStart: Radius.circular(16),
                          bottomEnd: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        localization.new_item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                // Price Pill
                Positioned(
                  bottom: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CustomPaint(
                      painter: PriceTagPainter(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                        child: Text(
                          '${price.toInt()} ${localization.currency}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 28), // Space for the overlapping pill
            
            // Details Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    // Cart icon button
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF3E3E3E) : const Color(0xFFEEEEEE),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: isDark ? Colors.white : Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PriceTagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path();
    final double w = size.width;
    final double h = size.height;
    
    final double sw = 4.0; // stroke width
    final double inset = 12.0; // horizontal inset for the TOP
    final double r = 8.0; // corner radius

    // Safe bounds taking stroke width into account
    final p1 = Offset(sw / 2, h - sw / 2); // Bottom-Left (No inset)
    final p2 = Offset(w - sw / 2, h - sw / 2); // Bottom-Right (No inset)
    final p3 = Offset(w - inset - sw / 2, sw / 2); // Top-Right (Inset)
    final p4 = Offset(inset + sw / 2, sw / 2); // Top-Left (Inset)

    double L = sqrt(inset * inset + h * h);
    double dx = (inset / L) * r;
    double dy = (h / L) * r;

    // Draw the rounded trapezoid path (narrow top, wide bottom)
    path.moveTo(p1.dx + r, p1.dy); // start at bottom left
    
    // Bottom edge
    path.lineTo(p2.dx - r, p2.dy);
    // Bottom-Right corner
    path.quadraticBezierTo(p2.dx, p2.dy, p2.dx - dx, p2.dy - dy);
    
    // Right slanted edge
    path.lineTo(p3.dx + dx, p3.dy + dy);
    // Top-Right corner
    path.quadraticBezierTo(p3.dx, p3.dy, p3.dx - r, p3.dy);
    
    // Top edge
    path.lineTo(p4.dx + r, p4.dy);
    // Top-Left corner
    path.quadraticBezierTo(p4.dx, p4.dy, p4.dx - dx, p4.dy + dy);
    
    // Left slanted edge
    path.lineTo(p1.dx + dx, p1.dy - dy);
    // Bottom-Left corner
    path.quadraticBezierTo(p1.dx, p1.dy, p1.dx + r, p1.dy);
    
    path.close();

    final fillPaint = Paint()
      ..color = const Color(0xFF161616)
      ..style = PaintingStyle.fill;
      
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

