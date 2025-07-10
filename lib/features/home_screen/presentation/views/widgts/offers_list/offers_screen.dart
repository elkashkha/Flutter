import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/offers/offers_cubit.dart';
import '../../../views_model/offers/offers_state.dart';
import 'offerlist_item.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;
    final screenHeight = mediaQuery.size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFCFCFC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.white,
          title: CustomAppBar(
            title: AppLocalizations.of(context)!.offers,
          ),
        ),
        body: BlocBuilder<OffersCubit, OffersState>(
          builder: (context, state) {
            if (state is OffersLoading) {
              return Center(
                child: SizedBox(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  child: const CustomDotsTriangleLoader(),
                ),
              );
            } else if (state is OffersError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                      color: Colors.red, fontSize: screenWidth * 0.04),
                ),
              );
            } else if (state is OffersLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(screenWidth * 0.02),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.025,
                  mainAxisSpacing: screenWidth * 0.025,
                  mainAxisExtent: screenHeight * 0.35,
                ),
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  final offer = state.offers[index];
                  return OfferlistItem(offer: offer);
                },
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: screenWidth * 0.15,
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'لا توجد عروض متاحة حاليًا',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
