import 'package:elkashkha/features/product_categories/presentation/view/widgets/product_categories_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ProductCategoriesView extends StatelessWidget {
  const ProductCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';


    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFCFCFC),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.white,
            title:  CustomAppBar(title: AppLocalizations.of(context)!.our_products,),
          ),
          body: const ProductCategoriesList(),


        ),
      ),
    );
  }
}