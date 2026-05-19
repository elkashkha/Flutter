import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../../core/widgets/loading.dart';
import '../../../../../../cart_screen/presentation/data/cart_repository.dart';
import '../../../../../../cart_screen/presentation/view_model/cart_cubit.dart';
import '../../../../../../cart_screen/presentation/view_model/cart_state.dart';
import 'product_model.dart';
import 'package:elkashkha/core/app_theme.dart';
import 'package:elkashkha/core/widgets/custom_button.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? selectedImage;
  String? token;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  void _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('access_token');
    });
  }

  void _cartListener(BuildContext context, CartState state) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (state is CartSuccess) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic ? 'تمت الإضافة' : 'Added to Cart',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily:
                        isArabic ? GoogleFonts.tajawal().fontFamily : null,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            isArabic
                ? 'تمت إضافة المنتج إلى العربة بنجاح.'
                : 'The product was successfully added to your cart.',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black87,
              fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? 'استمرار' : 'Continue',
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/CartScreen');
              },
              child: Text(
                isArabic ? 'عرض العربة' : 'View Cart',
                style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (state is CartError) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic ? 'خطأ' : 'Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily:
                        isArabic ? GoogleFonts.tajawal().fontFamily : null,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            isArabic
                ? 'حدث خطأ أثناء إضافة المنتج إلى العربة يرجى تسجيل الدخول أولاً.'
                : 'An error occurred while adding the product to the cart. Please login first.',
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black87,
              fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.push('/LoginScreenView');
              },
              child: Text(
                isArabic ? 'حسناً' : 'OK',
                style: TextStyle(
                  color: isDark ? Colors.white : AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildExpandableSection(
      {required String title,
      required List<String> items,
      required bool isArabic}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(
          title,
          style: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconColor: Colors.grey,
        collapsedIconColor: Colors.grey,
        children: items.where((item) => item.trim().isNotEmpty).map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: isDark ? Colors.white70 : Colors.black, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: GoogleFonts.tajawal(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final data = GoRouterState.of(context).extra as Map<String, dynamic>;
    final Product product = data['product'] as Product;

    selectedImage ??= product.images.isNotEmpty
        ? product.images.first
        : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKz9XsUJfaO-reUJ2o12yPP6I664jwnLfH8A&s";

    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (_) => CartCubit(CartRepository(Dio())),
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xff262626) : Colors.white,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: screenHeight * 0.45,
                    automaticallyImplyLeading: false,
                    backgroundColor: isDark ? const Color(0xff262626) : Colors.white,
                    pinned: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Main Image
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: selectedImage!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CustomDotsTriangleLoader()),
                                errorWidget: (context, url, error) => const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                          // Back Button
                          Positioned(
                            top: 24,
                            right: isArabic ? 24 : null,
                            left: isArabic ? null : 24,
                            child: InkWell(
                              onTap: () => context.pop(),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isArabic
                                      ? Icons.arrow_back
                                      : Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          // Thumbnails
                          if (product.images.length > 1)
                            Positioned(
                              top: 72,
                              left: isArabic ? 28 : null,
                              right: isArabic ? null : 28,
                              bottom: 56,
                              width: 50,
                              child: ListView.builder(
                                itemCount: product.images.length,
                                itemBuilder: (context, index) {
                                  final img = product.images[index];
                                  final isSelected = img == selectedImage;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedImage = img;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: CachedNetworkImage(
                                          imageUrl: img,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff262626) : Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      transform: Matrix4.translationValues(0, -30, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title Row
                            Text(
                              isArabic
                                  ? (product.nameAr ?? '')
                                  : (product.nameEn ?? ''),
                              style: GoogleFonts.tajawal(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Price Row
                            Row(
                              children: [
                                if (product.originalPrice >
                                    product.discountedPrice) ...[
                                  Text(
                                    "${product.originalPrice.toInt()} ${isArabic ? 'دينار' : 'KWD'}",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  "${product.discountedPrice.toInt()} ${isArabic ? 'دينار' : 'KWD'}",
                                  style: GoogleFonts.tajawal(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                if (product.originalPrice >
                                    product.discountedPrice) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic
                                        ? "لفترة محدودة"
                                        : "Limited time",
                                    style: GoogleFonts.tajawal(
                                      fontSize: 14,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            // Dynamic Details Container hiding
                            () {
                              final desc = isArabic ? product.descriptionAr : product.descriptionEn;
                              final ingredients = isArabic ? product.ingredientsAr : product.ingredientsEn;
                              final benefits = isArabic ? product.benefitsAr : product.benefitsEn;
                              final usage = isArabic ? product.usageInstructionsAr : product.usageInstructionsEn;

                              final hasDesc = desc.trim().isNotEmpty;
                              final hasIngredients = ingredients.where((i) => i.trim().isNotEmpty).isNotEmpty;
                              final hasBenefits = benefits.where((i) => i.trim().isNotEmpty).isNotEmpty;
                              final hasUsage = usage.trim().isNotEmpty;

                              final showDetailsContainer = hasDesc || hasIngredients || hasBenefits || hasUsage;

                              if (!showDetailsContainer) return const SizedBox.shrink();

                              return Column(
                                children: [
                                  const SizedBox(height: 24),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF9F9F9),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Description
                                        if (hasDesc) ...[
                                          Text(
                                            desc,
                                            style: GoogleFonts.tajawal(
                                              fontSize: 15,
                                              height: 1.5,
                                              color: isDark ? Colors.white70 : Colors.black87,
                                            ),
                                            textAlign: TextAlign.justify,
                                          ),
                                          if (hasIngredients || hasBenefits || hasUsage)
                                            const SizedBox(height: 16),
                                        ],
                                        // Ingredients
                                        if (hasIngredients) ...[
                                          _buildExpandableSection(
                                            title: isArabic
                                                ? "المكونات"
                                                : "Ingredients",
                                            items: ingredients,
                                            isArabic: isArabic,
                                          ),
                                          if (hasBenefits || hasUsage)
                                            const SizedBox(height: 12),
                                        ],
                                        // Benefits
                                        if (hasBenefits) ...[
                                          _buildExpandableSection(
                                            title: isArabic
                                                ? "فوائد المنتج"
                                                : "Benefits",
                                            items: benefits,
                                            isArabic: isArabic,
                                          ),
                                          if (hasUsage)
                                            const SizedBox(height: 12),
                                        ],
                                        // Usage instructions
                                        if (hasUsage)
                                          _buildExpandableSection(
                                            title: isArabic
                                                ? "طريقة الاستخدام"
                                                : "Usage Instructions",
                                            items: [usage],
                                            isArabic: isArabic,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Fixed Bottom Button
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: BlocConsumer<CartCubit, CartState>(
                    listener: _cartListener,
                    builder: (context, state) {
                      final bool isCartLoading = state is CartLoading;
                      return GestureDetector(
                        onTap: () {
                          if (token == null) {
                            context.push('/LoginScreenView');
                          } else {
                            if (!isCartLoading) {
                              context.read<CartCubit>().addToCart(
                                productId: product.id,
                                quantity: 1,
                              );
                            }
                          }
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFF161616),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: isCartLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  isArabic ? "اطلب الان" : "Order Now",
                                  style: GoogleFonts.tajawal(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
