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

  void _sendToWhatsapp(String name, String price, BuildContext context) async {
    const String whatsappNumber = "96555156388";
    final Uri whatsappUrl = Uri.parse(
        "https://wa.me/$whatsappNumber?text=مرحبًا! أرغب في شراء المنتج $name بسعر $price دينار.");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يبدو أن WhatsApp غير مثبت على الجهاز."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    final data = GoRouterState.of(context).extra as Map<String, dynamic>;
    final Product product = data['product'] as Product;

    selectedImage ??= product.images.isNotEmpty
        ? product.images.first
        : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKz9XsUJfaO-reUJ2o12yPP6I664jwnLfH8A&s";

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: BlocProvider(
        create: (_) => CartCubit(CartRepository(Dio())),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(isArabic ? 'تفاصيل المنتج' : 'Product Details'),
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: selectedImage!,
                      height: screenHeight * 0.35,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                      const Center(child: CustomDotsTriangleLoader()),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.1,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImage = product.images[index];
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selectedImage == product.images[index]
                                    ? Colors.blue
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: product.images[index],
                                width: screenWidth * 0.2,
                                height: screenHeight * 0.1,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      Icon(Icons.star,
                          color: Colors.amber, size: screenWidth * 0.05),
                      const SizedBox(width: 5),
                      Text(
                        product.averageRating.toStringAsFixed(1),
                        style: GoogleFonts.tajawal(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    isArabic
                        ? product.nameAr ?? 'اسم المنتج'
                        : product.nameEn ?? 'Product Name',
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    children: [
                      Text(
                        "${product.discountedPrice} ${isArabic ? 'دينار' : 'KWD'}",
                        style: GoogleFonts.tajawal(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      if (product.originalPrice > product.discountedPrice)
                        Text(
                          "${product.originalPrice} ${isArabic ? 'دينار' : 'KWD'}",
                          style: GoogleFonts.tajawal(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    isArabic
                        ? product.descriptionAr ?? 'لا يوجد وصف متاح'
                        : product.descriptionEn ?? 'No description available',
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.tajawal(
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  if ((isArabic ? product.ingredientsAr : product.ingredientsEn)
                      .isNotEmpty) ...[
                    Text(
                      isArabic ? "المكونات:" : "Ingredients:",
                      style: GoogleFonts.tajawal(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (isArabic
                          ? product.ingredientsAr
                          : product.ingredientsEn)
                          .map((ingredient) => Padding(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          "- $ingredient",
                          style: GoogleFonts.tajawal(
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ))
                          .toList(),
                    ),
                  ],
                  SizedBox(height: screenHeight * 0.03),
                  if ((isArabic ? product.benefitsAr : product.benefitsEn)
                      .isNotEmpty) ...[
                    Text(
                      isArabic ? "الفوائد:" : "Benefits:",
                      style: GoogleFonts.tajawal(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...product.benefitsAr.map((benefit) => Text("- $benefit")),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                  if ((isArabic
                      ? product.usageInstructionsAr
                      : product.usageInstructionsEn)
                      .isNotEmpty) ...[
                    Text(
                      isArabic ? "طريقة الاستخدام:" : "Usage Instructions:",
                      style: GoogleFonts.tajawal(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      isArabic
                          ? product.usageInstructionsAr
                          : product.usageInstructionsEn,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: BlocConsumer<CartCubit, CartState>(
                        listener: (context, state) {
                          if (state is CartSuccess) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                titlePadding:
                                const EdgeInsets.fromLTRB(24, 24, 24, 0),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                actionsPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                title: Row(
                                  children: [
                                    const Icon(Icons.check_circle_rounded,
                                        color: Colors.green, size: 28),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        isArabic
                                            ? 'تمت الإضافة'
                                            : 'Added to Cart',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: isArabic
                                              ? GoogleFonts.tajawal().fontFamily
                                              : null,
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
                                    fontFamily: isArabic
                                        ? GoogleFonts.tajawal().fontFamily
                                        : null,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      isArabic ? 'استمرار' : 'Continue',
                                      style: const TextStyle(
                                        color: AppTheme.primary,
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
                                      style: const TextStyle(
                                        color: AppTheme.primary,
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Row(
                                  children: [
                                    const Icon(Icons.error_outline,
                                        color: Colors.red, size: 28),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        isArabic ? 'خطأ' : 'Error',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: isArabic
                                              ? GoogleFonts.tajawal().fontFamily
                                              : null,
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
                                    fontFamily: isArabic
                                        ? GoogleFonts.tajawal().fontFamily
                                        : null,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.push('/LoginScreenView');
                                    },
                                    child: Text(
                                      isArabic ? 'حسناً' : 'OK',
                                      style: const TextStyle(
                                        color: AppTheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (token == null) {
                            return MyCustomButton(
                              text: isArabic
                                  ? 'يرجى تسجيل الدخول لطلب الأوردر'
                                  : 'Please login to order',
                              voidCallback: () {
                                context.push('/LoginScreenView');
                              },
                            );
                          }

                          return MyCustomButton(
                            text: isArabic ? 'أضف إلى العربة' : 'Add to Cart',
                            voidCallback: () {
                              context.read<CartCubit>().addToCart(
                                productId: product.id,
                                quantity: 1,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
