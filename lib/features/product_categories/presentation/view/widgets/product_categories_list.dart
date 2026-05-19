import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/loading.dart';
import '../../view_model/product_categories_cubit.dart';
import '../../view_model/product_categories_state.dart';
import 'product_categories_item.dart';

class ProductCategoriesList extends StatelessWidget {
  const ProductCategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return BlocBuilder<ProductCategoriesCubit, ProductCategoriesState>(
      builder: (context, state) {
        if (state is ProductCategoriesLoading) {
          return const Center(child: CustomDotsTriangleLoader());
        } else if (state is ProductCategoriesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else if (state is ProductCategoriesLoaded) {
          if (state.categories.isEmpty) {
            return const Center(child: Text('لا توجد بيانات متاحة'));
          }

          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.9,
            ),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];

              return ProductCategoriesItem(
                title: locale.languageCode == 'ar' ? category.nameAr : category.nameEn,
                categoryId: category.id,
              );
            },
          );
        }
        return const Center(child: Text('لا توجد بيانات متاحة'));
      },
    );
  }
}
