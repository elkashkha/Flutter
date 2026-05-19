import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/widgets/loading.dart';
import '../../views_model/search_screen/search_cubit.dart';
import '../../views_model/search_screen/search_state.dart';
import '../../views_model/services/service_cubit.dart';
import '../../views_model/services/service_state.dart';
import '../../views_model/services/services_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale == 'ar';

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Column(
          children: [
            // ─── 1. Custom Dark Header ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (!isArabic)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        searchCubit.searchServices(''); // reset search
                        context.push('/NavBarView');
                      },
                    )
                  else
                    const Spacer(),
                  Text(
                    isArabic ? 'البحث' : 'Search',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isArabic)
                    IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        searchCubit.searchServices(''); // reset search
                        context.push('/NavBarView');
                      },
                    )
                  else
                    const Spacer(),
                ],
              ),
            ),

            // ─── 2. White Card Content Area ───
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    // Search text field
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (query) {
                                searchCubit.searchServices(query);
                                setState(() {});
                              },
                              style: GoogleFonts.tajawal(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                hintText: isArabic ? 'بحث...' : 'Search...',
                                hintStyle: GoogleFonts.tajawal(
                                  color: Colors.grey.shade400,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),

                    // Main dynamic content
                    Expanded(
                      child: BlocBuilder<SearchCubit, SearchState>(
                        builder: (context, state) {
                          if (state is SearchLoading) {
                            return const Center(child: CustomDotsTriangleLoader());
                          }

                          if (state is SearchLoaded) {
                            final results = state.services;
                            if (results.isEmpty) {
                              return _buildEmptyState(isArabic);
                            }
                            return _buildSearchResultsList(results, isArabic);
                          }

                          if (state is SearchError) {
                            if (_searchController.text.isEmpty) {
                              return _buildInitialState(context, isArabic);
                            }
                            return _buildEmptyState(isArabic);
                          }

                          // Default / SearchInitial state
                          return _buildInitialState(context, isArabic);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // ── "خدمات اخرى قد تعجبك" Section ──
          _buildRecommendedServices(context, isArabic),
        ],
      ),
    );
  }

  Widget _buildRecommendedServices(BuildContext context, bool isArabic) {
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
              child: Text(
                isArabic ? 'خدمات اخرى قد تعجبك' : 'Other services you might like',
                style: GoogleFonts.tajawal(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 185,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: services.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final svc = services[index];
                  return RecommendedServiceCard(
                    service: svc,
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
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildSearchResultsList(List<dynamic> results, bool isArabic) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final service = results[index];
        final name = isArabic ? service.nameAr : service.nameEn;
        final desc = isArabic ? service.descriptionAr : service.descriptionEn;

        return GestureDetector(
          onTap: () {
            context.push(
              '/ServiceDetails',
              extra: {
                'service': {
                  'imageUrl': service.imageUrl,
                  'name_ar': service.nameAr,
                  'name_en': service.nameEn,
                  'price': service.price,
                  'rate': service.averageRating,
                  'duration': service.duration,
                  'description_ar': service.descriptionAr,
                  'description_en': service.descriptionEn,
                  'details': {
                    'tools': service.details.tools,
                    'staff': service.details.staff,
                  },
                  'reviews': service.reviews,
                },
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: service.imageUrl.isNotEmpty
                        ? service.imageUrl
                        : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const Center(child: CustomDotsTriangleLoader()),
                    errorWidget: (_, __, ___) =>
                        const Icon(Icons.error, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.tajawal(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.tajawal(
                          fontSize: 11,
                          color: Colors.black45,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            service.averageRating.toStringAsFixed(1),
                            style: GoogleFonts.tajawal(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${service.price} ${isArabic ? 'دينار' : 'KWD'}',
                            style: GoogleFonts.tajawal(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFBA1A1A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isArabic) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/undraw_the-search_cjxa (1) 2.svg',
            width: 200,
            height: 160,
          ),
          const SizedBox(height: 20),
          Text(
            isArabic ? 'لم نجد اي نتائج مطابقة لبحثك' : 'No matching results found',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedServiceCard extends StatelessWidget {
  final Service service;
  final bool isArabic;
  final VoidCallback onTap;

  const RecommendedServiceCard({
    super.key,
    required this.service,
    required this.isArabic,
    required this.onTap,
  });

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
  Widget build(BuildContext context) {
    final name = isArabic ? service.nameAr : service.nameEn;
    final desc = isArabic ? service.descriptionAr : service.descriptionEn;
    final iconPath = _serviceIcons[service.id] ?? _defaultIcon;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F0F0),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF2C2C2C),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${service.price} ${isArabic ? 'دينار' : 'KWD'}',
                    style: GoogleFonts.tajawal(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
                color: Colors.black87,
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
                color: Colors.black45,
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
                    color: Colors.black54,
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
