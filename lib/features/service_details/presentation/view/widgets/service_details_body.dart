import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../home_screen/presentation/views_model/services/service_cubit.dart';
import '../../../../home_screen/presentation/views_model/services/service_state.dart';
import '../../../../home_screen/presentation/views_model/services/services_model.dart';
import '../../../../rate_screen/presentation/view/widgtes/item_rate.dart';

class ServiceDetailsBody extends StatefulWidget {
  const ServiceDetailsBody({super.key});

  @override
  State<ServiceDetailsBody> createState() => _ServiceDetailsBodyState();
}

class _ServiceDetailsBodyState extends State<ServiceDetailsBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  /// Maps service IDs to local SVG icon paths (reused from services_list)
  static const Map<int, String> _serviceIcons = {
    40: 'assets/service/scissor.svg',
    31: 'assets/service/trimmer.svg',
    33: 'assets/service/skin-care.svg',
    42: 'assets/service/skin-care.svg',
    38: 'assets/service/hair-color.svg',
    34: 'assets/service/hair-spray.svg',
    32: 'assets/service/blow-dryer.svg',
    39: 'assets/service/hair-spray.svg',
  };
  static const String _defaultIcon = 'assets/service/scissor.svg';

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

  String getLocalizedText(
      BuildContext context, String arabicText, String englishText) {
    Locale currentLocale = Localizations.localeOf(context);
    return currentLocale.languageCode == 'ar' ? arabicText : englishText;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Map<String, dynamic> data =
        GoRouterState.of(context).extra as Map<String, dynamic>;
    final Map<String, dynamic> service = data['service'] ?? {};

    final int serviceId = service['id'] ?? 0;
    final String iconPath = _serviceIcons[serviceId] ?? _defaultIcon;
    final String imageUrl =
        service['imageUrl'] ?? 'https://via.placeholder.com/150';
    final String nameAr = service['name_ar'] ?? 'اسم غير متوفر';
    final String nameEn = service['name_en'] ?? 'Name not available';
    final String price = service['price'] ?? 'غير متوفر';
    final double rate = (service['rate'] ?? 0).toDouble();
    final String descriptionAr =
        service['description_ar'] ?? 'لا يوجد وصف متاح';
    final String descriptionEn =
        service['description_en'] ?? 'No description available';
    final String duration = service['duration'] ?? 'غير محددة';
    final List<String> tools =
        List<String>.from(service['details']?['tools'] ?? []);
    final List<dynamic> reviews = service['reviews'] ?? [];
    final List<Map<String, dynamic>> approvedReviews = reviews
        .where((review) => review['status'] == 'معتمد')
        .map((review) => review as Map<String, dynamic>)
        .toList();

    // Image list – just one for now, but prepared for multiple
    final List<String> images = [imageUrl];

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
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              // ── 2. Rating, name, price ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Name
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            getLocalizedText(context, nameAr, nameEn),
                            style: GoogleFonts.tajawal(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Color(0xFFFFC107), size: 20),
                            const SizedBox(width: 4),
                            Text(
                              rate.toStringAsFixed(1),
                              style: GoogleFonts.tajawal(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "$price ${getLocalizedText(context, 'دينار', 'KWD')}",
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFBA1A1A),
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
                        text: getLocalizedText(
                            context, 'عن الخدمة', 'About Service')),
                    Tab(
                        text: getLocalizedText(
                            context, 'اراء العملاء', 'Reviews')),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── 4. Tab content ──
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _tabController.index == 0
                    ? _buildAboutTab(
                        context,
                        screenWidth,
                        descriptionAr,
                        descriptionEn,
                        tools,
                        duration,
                        isArabic,
                      )
                    : _buildReviewsTab(
                        context,
                        screenWidth,
                        approvedReviews,
                      ),
              ),

              // ── 5. Other services section ──
              _buildOtherServicesSection(context, isArabic),

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
                      ? getLocalizedText(context, 'احجز الآن', 'Book Now')
                      : getLocalizedText(context, 'يرجى تسجيل الدخول للحجز', 'Login to Book'),
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
    BuildContext context,
    double screenWidth,
    String descriptionAr,
    String descriptionEn,
    List<String> tools,
    String duration,
    bool isArabic,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      key: const ValueKey('about'),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            getLocalizedText(context, descriptionAr, descriptionEn),
            textAlign: TextAlign.justify,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              height: 1.8,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // Service details header
          Text(
            getLocalizedText(context, 'تفاصيل الخدمة', 'Service Details'),
            style: GoogleFonts.tajawal(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Tools checklist
          if (tools.isNotEmpty)
            ...tools.map(
              (tool) => Padding(
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
                        tool,
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
              getLocalizedText(
                  context, 'لا توجد أدوات متاحة.', 'No tools available.'),
              style: GoogleFonts.tajawal(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
            ),

          const SizedBox(height: 16),

          // Duration badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                  "${getLocalizedText(context, 'مدة الخدمة', 'Duration')}: $duration ${getLocalizedText(context, 'دقيقة', 'min')}",
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
  //  Reviews Tab
  // ════════════════════════════════════════════════════
  Widget _buildReviewsTab(
    BuildContext context,
    double screenWidth,
    List<Map<String, dynamic>> approvedReviews,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      key: const ValueKey('reviews'),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getLocalizedText(context, 'آراء العملاء', 'Customer Reviews'),
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/RateList'),
                child: Text(
                  getLocalizedText(context, 'عرض المزيد', 'Show More'),
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : AppTheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (approvedReviews.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: approvedReviews.length,
              separatorBuilder: (_, __) => Divider(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                height: 24,
              ),
              itemBuilder: (context, index) {
                final review = approvedReviews[index];
                return RateService(
                  name: review['user']?['name'] ?? 'مستخدم مجهول',
                  rating: review['rating'] ?? 0,
                  comment: review['comment'] ?? 'لا يوجد تعليق',
                  userImage: review['user']?['image_url'],
                  reviewDate: review['created_at'] ?? 'غير متوفر',
                );
              },
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.rate_review_outlined,
                        size: 48, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
                    const SizedBox(height: 12),
                    Text(
                      getLocalizedText(context, 'لا توجد مراجعات حتى الآن.',
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
  //  Other Services Section
  // ════════════════════════════════════════════════════
  Widget _buildOtherServicesSection(BuildContext context, bool isArabic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is! ServicesLoaded) return const SizedBox.shrink();

        final services = state.services;
        if (services.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Text(
                    getLocalizedText(context, 'خدمات اخرى', 'Other Services'),
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ':',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final svc = services[index];
                  return _OtherServiceCard(
                    service: svc,
                    iconPath: _serviceIcons[svc.id] ?? _defaultIcon,
                    isArabic: isArabic,
                    onTap: () {
                      context.push(
                        '/ServiceDetails',
                        extra: {
                          'service': {
                            'imageUrl': svc.imageUrl,
                            'name_ar': svc.nameAr,
                            'name_en': svc.nameEn,
                            'price': svc.price,
                            'rate': svc.averageRating,
                            'duration': svc.duration,
                            'description_ar': svc.descriptionAr,
                            'description_en': svc.descriptionEn,
                            'details': {
                              'tools': svc.details.tools,
                              'staff': svc.details.staff,
                            },
                            'reviews': svc.reviews,
                          },
                        },
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
//  Other Service Card Widget
// ════════════════════════════════════════════════════
class _OtherServiceCard extends StatelessWidget {
  final Service service;
  final String iconPath;
  final bool isArabic;
  final VoidCallback onTap;

  const _OtherServiceCard({
    required this.service,
    required this.iconPath,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = isArabic ? service.nameAr : service.nameEn;
    final desc = isArabic ? service.descriptionAr : service.descriptionEn;
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
                    child: SvgPicture.asset(
                      iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        isDark ? Colors.white70 : const Color(0xFF2C2C2C),
                        BlendMode.srcIn,
                      ),
                    ),
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
                    '${service.price} ${isArabic ? 'دينار' : 'KWD'}',
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
            // Rating
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                const SizedBox(width: 3),
                Text(
                  service.averageRating.toStringAsFixed(1),
                  style: GoogleFonts.tajawal(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
