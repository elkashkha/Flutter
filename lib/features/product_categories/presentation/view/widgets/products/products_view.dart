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
  final int? categoryId;

  const ProductList({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) {
        final cubit = ProductCubit();
        if (categoryId == null || categoryId == -1 || categoryId == 0) {
          cubit.fetchAllProducts();
        } else {
          cubit.fetchProductsByCategory(categoryId!);
        }
        return cubit;
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff0B0B0F) : const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xff0B0B0F) : const Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            AppLocalizations.of(context)!.our_products,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      context.pop();
                    }
                  },
                )
              : null,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            child: BlocBuilder<ProductCubit, ProductState>(
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
                  mainAxisExtent: 360,
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
      ),
    )
    );
  }
}
