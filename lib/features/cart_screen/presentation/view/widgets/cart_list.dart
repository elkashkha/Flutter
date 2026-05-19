import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../booking/paymet_wepView.dart';
import '../../view_model/cart_cubit.dart';
import '../../view_model/cart_state.dart';
import 'cart_list_item.dart';

class CartList extends StatelessWidget {
  final bool isArabic;

  const CartList({super.key, this.isArabic = true});

  // void _showSuccessDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Image.asset(
  //             'assets/images/undraw_celebrating_2aox 1.png',
  //             height: 80,
  //             width: 80,
  //           ),
  //           const SizedBox(height: 12),
  //           Text(
  //             isArabic ? 'تم حجز الطلب' : 'Order Placed Successfully',
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.green,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           const SizedBox(height: 12),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text(isArabic ? 'موافق' : 'OK'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> _openWhatsAppWithCartData(
      BuildContext context, CartCubit cubit) async {
    final state = cubit.state;
    if (state is! CartLoaded) return;

    final cartData = state.cartData;

    if (cartData.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'السلة فارغة' : 'Cart is empty')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln(isArabic ? 'تفاصيل الطلب:' : 'Order Details:');
    buffer.writeln();

    for (var item in cartData.items) {
      final product = item.product;
      final name = isArabic ? product.nameAr : product.nameEn;
      buffer.writeln('• $name');
      buffer.writeln('${isArabic ? "الكمية" : "Qty"}: ${item.quantity}');
      buffer.writeln(
          '${isArabic ? "السعر" : "Price"}: ${product.discountedPrice.toStringAsFixed(2)} دينار');
      buffer.writeln();
    }

    buffer.writeln(isArabic
        ? 'الإجمالي: ${cartData.totalPrice.toStringAsFixed(2)} دينار'
        : 'Total: ${cartData.totalPrice.toStringAsFixed(2)} JOD');

    final message = Uri.encodeComponent(buffer.toString());
    const phone = '96555156388';
    final url = 'https://wa.me/$phone?text=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text(isArabic ? 'لا يمكن فتح واتساب' : 'Cannot open WhatsApp')),
      );
    }
  }

  void _showCheckoutBottomSheet(BuildContext context, dynamic cartData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'المجموع الفرعي' : 'Subtotal',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                      fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                  Text(
                    isArabic ? '${cartData.totalPrice.toStringAsFixed(0)} دينار' : '${cartData.totalPrice.toStringAsFixed(0)} KWD',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                      fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300, thickness: 0.5),
              const SizedBox(height: 20),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isArabic ? 'المجموع الكلي' : 'Total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                  Text(
                    isArabic ? '${cartData.totalPrice.toStringAsFixed(0)} دينار' : '${cartData.totalPrice.toStringAsFixed(0)} KWD',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Confirm button
              GestureDetector(
                onTap: () {
                  Navigator.pop(bottomSheetContext); // Close bottom sheet
                  context.read<CartCubit>().checkout(context); // Run checkout
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFF161616),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isArabic ? 'تأكيد الحجز' : 'Confirm Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    context.read<CartCubit>().getCart();

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CheckoutSuccess) {
          Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => BookingWebViewScreen(url: state.InvoiceURL),
            ),
          ).then((_) async {
            await _openWhatsAppWithCartData(context, context.read<CartCubit>());
            // _showSuccessDialog(context);
          });
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              content: Text(
                isArabic ? 'يرجى التسجيل أولاً' : 'Please register first',
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CustomDotsTriangleLoader());
        } else if (state is CartLoaded) {
          final cartData = state.cartData;

          if (cartData.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/cart_empty.svg',
                    height: 150,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isArabic
                        ? 'سلة التسوق فارغة\nاكتشف منتجاتنا وقم بطلبها'
                        : 'Shopping Cart is Empty\nDiscover our products and order them',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      height: 1.5,
                      fontFamily:
                          isArabic ? GoogleFonts.tajawal().fontFamily : null,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartData.items.length,
                  itemBuilder: (context, index) {
                    final item = cartData.items[index];
                    return CartItemWidget(
                      item: item,
                      isArabic: isArabic,
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    _showCheckoutBottomSheet(context, cartData);
                  },
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isArabic ? 'إتمام الشراء' : 'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is CartError) {
          return Center(
              child: Text(
                  isArabic ? 'يرجى التسجيل أولاً' : 'Please register first',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontFamily: isArabic ? GoogleFonts.tajawal().fontFamily : null,
                  )));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
