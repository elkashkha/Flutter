import 'package:dio/dio.dart';
import 'package:elkashkha/core/widgets/logo_scissors.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/teams_list_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/search_bar.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_list.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/flutter_local_notifications/view_model/unread_notifications_cubit.dart';
import '../../../../product_categories/presentation/view/widgets/products/product_home_list.dart';
import '../../../../profile_screen/presentation/view/widgets/about_us/view_model/teams_view.dart';
import '../../views_model/offers/offers_cubit.dart';
import '../../views_model/offers/offers_state.dart';
import '../../views_model/user_greeting_widget.dart';
import 'banner_home.dart';
import 'offers_list/offer_list.dart';
import 'package/package_list.dart';
import 'salon_video_widget.dart';

class HomeScreenViewBody extends StatelessWidget {
  const HomeScreenViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: screenWidth,
            color: isDark ? const Color(0xff0B0B0F) : Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const LogoScissors(),
                        Row(
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFf3f3f3),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.shopping_cart_sharp,
                                    color: isDark ? Colors.white : Colors.black, size: 20),
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  context.push('/CartScreen');
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            BlocProvider(
                              create: (_) => UnreadNotificationsCubit(Dio())
                                ..getUnreadCount(),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFf3f3f3),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.notifications_active_outlined,
                                        color: isDark ? Colors.white : Colors.black,
                                        size: 24,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        context.push('/NotificationsScreen');
                                      },
                                    ),
                                  ),
                                  BlocBuilder<UnreadNotificationsCubit,
                                      UnreadNotificationsState>(
                                    builder: (context, state) {
                                      if (state is UnreadNotificationsLoaded &&
                                          state.count > 0) {
                                        return Positioned(
                                          right: 0,
                                          top: 1,
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
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
                  const UserNameWidget(),
                  SizedBox(height: screenHeight * 0.015),
                  Center(
                    child: SizedBox(
                      width: screenWidth * 0.85,
                      child: const SearchField(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          const MyCarouselSlider(),
          SizedBox(height: screenHeight * 0.02),
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
                }, showArrow: false),
                const ListService(),
              ],
            ),
          ),
          const HomeBannerWidget(),
          BlocBuilder<OffersCubit, OffersState>(
            builder: (context, state) {
              if (state is OffersLoaded && state.offers.isNotEmpty) {
                return Padding(
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
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.02,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04),
            child: const SalonVideoWidget(
              videoUrl: 'https://res.cloudinary.com/dykjgar3u/video/upload/v1779110365/WhatsApp_Video_2026-05-18_at_3.18.28_PM_mwlolo.mp4',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight * 0.02,
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
          // Padding(
          //   padding: EdgeInsets.only(
          //       top: screenHeight * 0.005,
          //       left: screenWidth * 0.04,
          //       right: screenWidth * 0.04),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       _buildSectionHeader(context, localization.latest_products, () {
          //         context.push('/ProductCategoriesView');
          //       }),
          //       const ProductHomeList(categoryId: 15),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(
                bottom: screenHeight * 0.02,
                top: screenHeight * 0.01,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, localization.specialists, () {
                  context.push('/TeamsListHome');
                }),
                const SpecialistsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, VoidCallback onMorePressed,
      {bool showArrow = true}) {
    var localization = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width > 600
        ? MediaQuery.of(context).size.width * .75
        : MediaQuery.of(context).size.width;
    final locale = Localizations.localeOf(context).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: GestureDetector(
        onTap: onMorePressed,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              title,
              style: GoogleFonts.notoNaskhArabic(
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationColor: isDark ? Colors.white : Colors.black,
                decorationThickness: 1.5,
              ),
            ),
            if (showArrow)
              Transform.rotate(
                angle: locale == 'ar' ? 0 : 3.141592653589793,
                child: SvgPicture.asset(
                  'assets/images/arrow_icon.svg',
                  width: 35,
                  height: 35,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
