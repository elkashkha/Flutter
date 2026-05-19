import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/offers/offers_cubit.dart';
import '../../../views_model/offers/offers_model.dart';
import '../../../views_model/offers/offers_state.dart';

class OffersDetailsBody extends StatefulWidget {
  const OffersDetailsBody({super.key});

  @override
  State<OffersDetailsBody> createState() => _OffersDetailsBodyState();
}

class _OffersDetailsBodyState extends State<OffersDetailsBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _dragController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _dragController.dispose();
    super.dispose();
  }

  String _getLocalizedText(
      BuildContext context, String arabicText, String englishText) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? arabicText
        : englishText;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details, double screenHeight) {
    if (_dragController.value == 1.0) return;
    _dragController.value -= details.primaryDelta! / screenHeight;
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_dragController.value == 1.0) return;
    if (_dragController.value > 0.15 || details.primaryVelocity! < -300) {
      _dragController.animateTo(1.0, curve: Curves.easeOutQuad);
    } else {
      _dragController.animateTo(0.0, curve: Curves.easeOutQuad);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, dynamic> data =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final Offer offer = data['offer'];
    final List<String> images = [offer.imageUrl];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      body: AnimatedBuilder(
        animation: _dragController,
        builder: (context, child) {
          final double slideValue = _dragController.value;
          return Stack(
            fit: StackFit.expand,
            children: [
              // ─── 1. Details Page (Sits at the bottom/behind) ───
              IgnorePointer(
                ignoring: slideValue < 1.0,
                child: Scaffold(
                  backgroundColor:
                      isDark ? const Color(0xff151414) : Colors.white,
                  body: SafeArea(
                    top: true,
                    child: SingleChildScrollView(
                      physics: slideValue == 1.0
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── 1. Hero image with page indicator (rounded corners, padded) ──
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.32,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.06),
                                        blurRadius: 16,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [
                                        PageView.builder(
                                          controller: _pageController,
                                          itemCount: images.length,
                                          onPageChanged: (i) =>
                                              setState(() => _currentPage = i),
                                          itemBuilder: (_, i) =>
                                              CachedNetworkImage(
                                            imageUrl: images[i].isNotEmpty
                                                ? images[i]
                                                : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => const Center(
                                                child:
                                                    CustomDotsTriangleLoader()),
                                            errorWidget: (_, __, ___) =>
                                                const Center(
                                                    child: Icon(Icons.error,
                                                        size: 40)),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          left: isArabic ? null : 12,
                                          right: isArabic ? 12 : null,
                                          child: GestureDetector(
                                            onTap: () {
                                              _dragController.animateTo(0.0,
                                                  curve: Curves.easeOutQuad);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: Colors.white,
                                                  size: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (images.length > 1)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      images.length,
                                      (i) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        width: _currentPage == i ? 16 : 8,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: _currentPage == i
                                              ? (isDark
                                                  ? Colors.white
                                                  : Colors.black)
                                              : Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  _getLocalizedText(
                                      context, offer.titleAr, offer.titleEn),
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      "${offer.discountedPrice} ${_getLocalizedText(context, 'دينار', 'KWD')}",
                                      style: GoogleFonts.tajawal(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "${offer.originalPrice} ${_getLocalizedText(context, 'دينار', 'KWD')}",
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16,
                                        color: Colors.grey.shade400,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      _getLocalizedText(
                                          context,
                                          "صالح حتى ${offer.endDate}",
                                          "Valid until ${offer.endDate}"),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black45,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black
                                  : const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              onTap: (_) => setState(() {}),
                              indicator: BoxDecoration(
                                color: const Color(0xFF202020),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelColor: Colors.white,
                              unselectedLabelColor:
                                  isDark ? Colors.white60 : Colors.black54,
                              labelStyle: GoogleFonts.tajawal(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              unselectedLabelStyle: GoogleFonts.tajawal(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              tabs: [
                                Tab(
                                    text: _getLocalizedText(
                                        context, 'عن الخدمة', 'About')),
                                Tab(
                                    text: _getLocalizedText(
                                        context, 'اراء العملاء', 'Reviews')),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _tabController.index == 0
                                ? _buildAboutTab(context, offer, isArabic)
                                : _buildReviewsTab(context),
                          ),
                          _buildOtherOffersSection(context, offer, isArabic),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  bottomNavigationBar: slideValue > 0.0
                      ? Opacity(
                          opacity: slideValue.clamp(0.0, 1.0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                18, 12, 18, 12 + mediaQuery.padding.bottom),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xff151414)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: FutureBuilder<String?>(
                              future: SharedPreferences.getInstance()
                                  .then((p) => p.getString('access_token')),
                              builder: (ctx, snap) {
                                final hasToken =
                                    snap.data != null && snap.data!.isNotEmpty;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (hasToken) {
                                        context.push('/BookingService');
                                      } else {
                                        context.push('/LoginScreenView');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      hasToken
                                          ? _getLocalizedText(
                                              context, 'احجز الآن', 'Book Now')
                                          : _getLocalizedText(
                                              context,
                                              'يرجى تسجيل الدخول للحجز',
                                              'Login to Book'),
                                      style: GoogleFonts.tajawal(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : null,
                ),
              ),

              // ─── 2. Landing Page (Slides UP to reveal Details Page underneath) ───
              if (slideValue < 1.0)
                Transform.translate(
                  offset: Offset(0.0, -screenHeight * slideValue),
                  child: Column(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (d) =>
                              _onVerticalDragUpdate(d, screenHeight),
                          onVerticalDragEnd: _onVerticalDragEnd,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: offer.imageUrl.isNotEmpty
                                      ? offer.imageUrl
                                      : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => const Center(
                                      child: CustomDotsTriangleLoader()),
                                  errorWidget: (_, __, ___) => const Center(
                                      child: Icon(Icons.error, size: 40)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.25),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: mediaQuery.padding.top + 12,
                                right: isArabic ? 20 : null,
                                left: isArabic ? null : 20,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 30,
                                left: 0,
                                right: 0,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.keyboard_double_arrow_up_rounded,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isArabic
                                          ? 'مرر للاعلى لرؤية تفاصيل العرض'
                                          : 'Swipe up to see offer details',
                                      style: GoogleFonts.tajawal(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: isDark ? const Color(0xff151414) : Colors.white,
                        padding: EdgeInsets.fromLTRB(
                            20, 16, 20, 16 + mediaQuery.padding.bottom),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      '${offer.discountedPrice} ${isArabic ? 'دينار' : 'KWD'}',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFBA1A1A),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${offer.originalPrice} ${isArabic ? 'دينار' : 'KWD'}',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.grey.shade600
                                            : Colors.grey.shade400,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            FutureBuilder<String?>(
                              future: SharedPreferences.getInstance()
                                  .then((p) => p.getString('access_token')),
                              builder: (ctx, snap) {
                                final hasToken =
                                    snap.data != null && snap.data!.isNotEmpty;
                                return ElevatedButton(
                                  onPressed: () {
                                    if (hasToken) {
                                      context.push('/BookingService');
                                    } else {
                                      context.push('/LoginScreenView');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 28, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    hasToken
                                        ? (isArabic ? 'احجز الان' : 'Book Now')
                                        : (isArabic
                                            ? 'سجل للحجز'
                                            : 'Login to Book'),
                                    style: GoogleFonts.tajawal(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  About Tab
  // ════════════════════════════════════════════════════
  Widget _buildAboutTab(BuildContext context, Offer offer, bool isArabic) {
    final services = offer.package.services;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      key: const ValueKey('about'),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            _getLocalizedText(
                context, offer.descriptionAr, offer.descriptionEn),
            textAlign: TextAlign.justify,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              height: 1.8,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Services header
          Text(
            _getLocalizedText(context, 'تفاصيل الخدمة', 'Service Details'),
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Services checklist
          if (services.isNotEmpty)
            ...services.map(
              (service) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 13),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        service,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Text(
              _getLocalizedText(context, 'لا توجد خدمات متاحة ضمن العرض.',
                  'No services available for this offer.'),
              style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : Colors.black54),
            ),

          const SizedBox(height: 16),

          // Offer Code Badge
          if (offer.offerCode.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isDark ? const Color(0xFF1B3D22) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer,
                      size: 18, color: Color(0xFF43A047)),
                  const SizedBox(width: 6),
                  Text(
                    "${_getLocalizedText(context, 'كود العرض', 'Offer Code')}: ${offer.offerCode}",
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFF81C784)
                          : const Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  Reviews Tab (placeholder)
  // ════════════════════════════════════════════════════
  Widget _buildReviewsTab(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      key: const ValueKey('reviews'),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getLocalizedText(context, 'آراء العملاء', 'Customer Reviews'),
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.rate_review_outlined,
                      size: 48,
                      color:
                          isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    _getLocalizedText(context, 'لا توجد مراجعات حتى الآن.',
                        'No reviews yet.'),
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════
  //  Other Offers Section
  // ════════════════════════════════════════════════════
  Widget _buildOtherOffersSection(
      BuildContext context, Offer currentOffer, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<OffersCubit, OffersState>(
      builder: (context, state) {
        if (state is! OffersLoaded) return const SizedBox.shrink();

        // Filter out current offer
        final offers =
            state.offers.where((o) => o.id != currentOffer.id).toList();
        if (offers.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "${_getLocalizedText(context, 'عروض اخرى', 'Other Offers')} :",
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: offers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final off = offers[index];
                  return _OtherOfferCard(
                    offer: off,
                    isArabic: isArabic,
                    onTap: () {
                      context.push(
                        '/OffersDetails',
                        extra: {'offer': off},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════
//  Other Offer Card Widget
// ════════════════════════════════════════════════════
class _OtherOfferCard extends StatelessWidget {
  final Offer offer;
  final bool isArabic;
  final VoidCallback onTap;

  const _OtherOfferCard({
    required this.offer,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = isArabic ? offer.titleAr : offer.titleEn;
    final desc = isArabic ? offer.descriptionAr : offer.descriptionEn;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 155,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222121) : const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2D2C2C)
                          : const Color(0xFFF0F0F0),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(Icons.local_offer_outlined,
                          size: 24,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF2C2C2C)),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${offer.discountedPrice} ${isArabic ? 'دينار' : 'KWD'}',
                      style: GoogleFonts.tajawal(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Title
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              // Description snippet
              Text(
                desc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.tajawal(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : Colors.black45,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              // Original price strikethrough
              Text(
                '${offer.originalPrice} ${isArabic ? 'دينار' : 'KWD'}',
                style: GoogleFonts.tajawal(
                  fontSize: 11,
                  color: isDark ? Colors.white54 : Colors.black38,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ));
  }
}
