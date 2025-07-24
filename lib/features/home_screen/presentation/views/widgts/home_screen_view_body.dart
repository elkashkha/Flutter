import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/search_bar.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_list.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/flutter_local_notifications/view_model/unread_notifications_cubit.dart';
import '../../../../product_categories/presentation/view/widgets/products/product_home_list.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_view.dart';
import '../../views_model/user_greeting_widget.dart';
import 'banner_home.dart';
import 'offers_list/offer_list.dart';
import 'package/package_list.dart';

class HomeScreenViewBody extends StatelessWidget {
  const HomeScreenViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.08),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  color: AppTheme.primary,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const UserNameWidget(),
                            Row(
                              children: [
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF292828),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.shopping_cart_sharp,
                                        color: Colors.white,
                                        size: 20),
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      context.push('/CartScreen');
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                BlocProvider(
                                  create: (_) => UnreadNotificationsCubit(Dio())..getUnreadCount(),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF292828),
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.notifications_active_outlined,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            context.push('/NotificationsScreen');
                                          },
                                        ),
                                      ),


                                      BlocBuilder<UnreadNotificationsCubit, UnreadNotificationsState>(
                                        builder: (context, state) {
                                          if (state is UnreadNotificationsLoaded && state.count > 0) {
                                            return Positioned(
                                              right: 0,
                                              top: 0,
                                              child: Container(
                                                padding: const EdgeInsets.all(3),
                                                decoration: const BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${state.count}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return const SizedBox();
                                        },
                                      ),
                                    ],
                                  ),
                                )


                              ],
                            ),


                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      SizedBox(
                        width: screenWidth * 0.85,
                        child: const SearchField(),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.23,
                  left: 0,
                  right: 0,
                  child: const MyCarouselSlider(),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.06),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, localization.our_services, () {
                    context.push('/ServicesScreen');
                  }),
                  const ListService(),
                ],
              ),
            ),
            const HomeBannerWidget(),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, localization.offers, () {
                    context.push('/OffersScreen');
                  }),
                  const OfferList(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, localization.packages, () {
                    context.push('/PacageScreen');
                  }),
                  const PackageList(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.005,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, localization.latest_products,
                      () {
                    context.push('/ProductCategoriesView');
                  }),
                  const ProductHomeList(categoryId: 15),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.01,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, localization.specialists, () {
                    context.push('/TeamsListHome');
                  }),
                  const TeamsView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, VoidCallback onMorePressed) {
    var localization = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final locale = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TextButton(
            onPressed: onMorePressed,
            child: Text(
              localization.see_more,
              style:  GoogleFonts.notoNaskhArabic(
                fontSize: 20,
                color: AppTheme.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.primary,
                decorationThickness: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
