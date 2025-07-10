import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading.dart';
import '../../data/cart_model.dart';
import '../../view_model/cart_cubit.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final bool isArabic;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final screenSize = MediaQuery.of(context).size;
    final imageWidth = screenSize.width * 0.25;
    final imageHeight = screenSize.height * 0.18;
    final titleFontSize = screenSize.width * 0.045;
    final descFontSize = screenSize.width * 0.038;
    final priceFontSize = screenSize.width * 0.04;
    final horizontalPadding = screenSize.width * 0.03;
    final verticalPadding = screenSize.height * 0.01;
    final spacingBetween = screenSize.width * 0.03;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: product.images.isNotEmpty ? product.images.first : '',
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: imageWidth,
                    height: imageHeight,
                    color: Colors.grey[300],
                    child: const Center(child: CustomDotsTriangleLoader()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: imageWidth,
                    height: imageHeight,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),

              SizedBox(width: spacingBetween),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? product.nameAr : product.nameEn,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: verticalPadding),

                    Text(
                      isArabic ? product.descriptionAr : product.descriptionEn,
                      style: TextStyle(
                        fontSize: descFontSize,
                        color: AppTheme.primary,
                      ),
                    ),

                    SizedBox(height: verticalPadding * 2),

                    Row(
                      children: [
                        Text(
                          '${product.originalPrice.toStringAsFixed(2)} دينار',
                          style: TextStyle(
                            fontSize: descFontSize,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: spacingBetween),
                        Text(
                          '${product.discountedPrice.toStringAsFixed(2)} دينار',
                          style: TextStyle(
                            fontSize: priceFontSize,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: verticalPadding * 2),

                    Text(
                      'الكمية: ${item.quantity}',
                      style: TextStyle(
                        fontSize: descFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              context.read<CartCubit>().deleteCartItem(item.id);
            },
          ),
        ),
      ],
    );
  }
}
