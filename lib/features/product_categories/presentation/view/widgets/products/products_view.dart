import 'package:elkashkha/features/authentication/register/presentation/view/widgets/register_screen_body.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/products_cubit.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/products_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/loading.dart';
import 'product_item.dart';

class ProductList extends StatelessWidget {
  final int categoryId;

  const ProductList({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => ProductCubit()..fetchProductsByCategory(categoryId),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.white,
          title: CustomAppBar(
            title: AppLocalizations.of(context)!.our_products,

          ),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CustomDotsTriangleLoader());
            } else if (state is ProductError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (state is ProductLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 300,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];

                  return ProductItem(
                    imageUrl: product.images.isNotEmpty ? product.images[0] : '',
                    title: Localizations.localeOf(context).languageCode == 'ar'
                        ? product.nameAr
                        : product.nameEn ?? product.nameAr,
                    price: product.discountedPrice,
                    originalPrice: product.originalPrice,
                    rating: product.averageRating,
                    description: Localizations.localeOf(context).languageCode == 'ar'
                        ? product.descriptionAr
                        : product.descriptionEn ?? product.descriptionAr,
                    product: product,
                  );
                },
              );
            }
            return Center(child: Text(localization.no_data_available));
          },
        ),
      ),
    );
  }
}
