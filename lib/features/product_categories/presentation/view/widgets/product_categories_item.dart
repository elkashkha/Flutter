import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../core/widgets/loading.dart';

class ProductCategoriesItem extends StatelessWidget {
  final int categoryId;
  final String imageUrl;
  final String title;

  const ProductCategoriesItem({
    super.key,
    required this.categoryId,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/ProductList', extra: {'categoryId': categoryId});
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 160,
              height: 80,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CustomDotsTriangleLoader(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
