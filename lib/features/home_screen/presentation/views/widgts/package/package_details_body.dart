import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/packages/packages_cubit.dart';
import '../../../views_model/packages/packages_model.dart';
import '../../../views_model/packages/packages_state.dart';

class PackageDetailsBody extends StatefulWidget {
  const PackageDetailsBody({super.key});

  @override
  State<PackageDetailsBody> createState() => _PackageDetailsBodyState();
}

class _PackageDetailsBodyState extends State<PackageDetailsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _getLocalizedText(
      BuildContext context, String arabicText, String englishText) {
    return Localizations.localeOf(context).languageCode == 'ar'
        ? arabicText
        : englishText;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, dynamic> data =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final Package package = data['package'];

    // Image list – one for now, prepared for multiple
    final List<String> images = [package.imageUrl];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
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
                              onPageChanged: (i) => setState(() => _currentPage = i),
                              itemBuilder: (_, i) => CachedNetworkImage(
                                imageUrl: images[i].isNotEmpty
                                    ? images[i]
                                    : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    const Center(child: CustomDotsTriangleLoader()),
                                errorWidget: (_, __, ___) =>
                                    const Center(child: Icon(Icons.error, size: 40)),
                              ),
                            ),
                            // Back button
                            Positioned(
                              top: 12,
                              left: isArabic ? null : 12,
                              right: isArabic ? 12 : null,
                              child: GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white, size: 18),
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
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == i ? 16 : 8,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? (isDark ? Colors.white : Colors.black) : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── 2. Name + Price ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Name
                    Text(
                      _getLocalizedText(
                          context, package.nameAr, package.nameEn),
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Price row — discounted + original strikethrough (Premium Red + Strikethrough)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "${package.discountedPrice} ${_getLocalizedText(context, 'دينار', 'KWD')}",
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFBA1A1A),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${package.originalPrice} ${_getLocalizedText(context, 'دينار', 'KWD')}",
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: Colors.grey.shade400,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── 3. Tab bar ──
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : const Color(0xFFF2F2F2),
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
                  unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
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

              // ── 4. Tab content ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _tabController.index == 0
                    ? _buildAboutTab(context, package, isArabic)
                    : _buildReviewsTab(context),
              ),

              // ── 5. Other packages section ──
              _buildOtherPackagesSection(context, package, isArabic),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(18, 12, 18, 12 + mediaQuery.padding.bottom),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xff151414) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: FutureBuilder<String?>(
          future: SharedPreferences.getInstance().then((p) => p.getString('access_token')),
          builder: (ctx, snap) {
            final hasToken = snap.data != null && snap.data!.isNotEmpty;
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
                      ? _getLocalizedText(context, 'احجز الآن', 'Book Now')
                      : _getLocalizedText(context, 'يرجى تسجيل الدخول للحجز', 'Login to Book'),
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
    );
  }

  // ════════════════════════════════════════════════════
  //  About Tab
  // ════════════════════════════════════════════════════
  Widget _buildAboutTab(
      BuildContext context, Package package, bool isArabic) {
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
                context, package.descriptionAr, package.descriptionEn),
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
          if (package.services.isNotEmpty)
            ...package.services.map(
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
              _getLocalizedText(context, 'لا توجد خدمات متاحة.',
                  'No services available.'),
              style:
                  GoogleFonts.tajawal(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
            ),

          const SizedBox(height: 16),

          // Duration badge (using created_at date info)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2E241A) : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time,
                    size: 18, color: Color(0xFFFF9800)),
                const SizedBox(width: 6),
                Text(
                  "${_getLocalizedText(context, 'مدة الخدمة', 'Duration')}: 30 ${_getLocalizedText(context, 'دقيقة', 'min')}",
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFE65100),
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
  //  Reviews Tab (placeholder — packages have no reviews)
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
                      size: 48, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    _getLocalizedText(context,
                        'لا توجد مراجعات حتى الآن.', 'No reviews yet.'),
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
  //  Other Packages Section
  // ════════════════════════════════════════════════════
  Widget _buildOtherPackagesSection(
      BuildContext context, Package currentPackage, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<PackagesCubit, PackagesState>(
      builder: (context, state) {
        if (state is! PackagesLoaded) return const SizedBox.shrink();

        // Filter out the current package
        final packages = state.packages
            .where((p) => p.id != currentPackage.id)
            .toList();
        if (packages.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                "${_getLocalizedText(context, 'باقات اخرى', 'Other Packages')} :",
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
                itemCount: packages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return _OtherPackageCard(
                    package: pkg,
                    isArabic: isArabic,
                    onTap: () {
                      context.push(
                        '/PackageDetails',
                        extra: {'package': pkg},
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
//  Other Package Card Widget
// ════════════════════════════════════════════════════
class _OtherPackageCard extends StatelessWidget {
  final Package package;
  final bool isArabic;
  final VoidCallback onTap;

  const _OtherPackageCard({
    required this.package,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = isArabic ? package.nameAr : package.nameEn;
    final desc = isArabic ? package.descriptionAr : package.descriptionEn;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 155,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF222121) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
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
                    color: isDark ? const Color(0xFF2D2C2C) : const Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: package.imageUrl.isNotEmpty ? package.imageUrl : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                      width: 24,
                      height: 24,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (_, __, ___) => Center(
                        child: Icon(Icons.card_giftcard, size: 20, color: isDark ? Colors.white70 : const Color(0xFF2C2C2C)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${package.discountedPrice} ${isArabic ? 'دينار' : 'KWD'}',
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
            // Name
            Text(
              name,
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
              '${package.originalPrice} ${isArabic ? 'دينار' : 'KWD'}',
              style: GoogleFonts.tajawal(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.black38,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
