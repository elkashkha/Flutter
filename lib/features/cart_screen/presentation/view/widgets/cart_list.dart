import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
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
            SnackBar(content: Text(isArabic ? 'يرجى التسجيل أولاً' : 'Please register first')),
          );
        }
      },
      builder: (context, state) {
        if (state is CartLoading) {
          return const Center(child: CustomDotsTriangleLoader());
        } else if (state is CartLoaded) {
          final cartData = state.cartData;

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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.grey, thickness: 1),
                    const SizedBox(height: 8),
                    Text(
                      isArabic
                          ? 'المجموع الكلي: ${cartData.totalPrice.toStringAsFixed(2)} دينار'
                          : 'Total: ${cartData.totalPrice.toStringAsFixed(2)} JOD',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MyCustomButton(
                      text: isArabic ? 'إتمام الشراء' : 'Checkout',
                      voidCallback: () {
                        final cubit = context.read<CartCubit>();
                        cubit.checkout(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (state is CartError) {
          return Center(
              child: Text(
                  isArabic ? 'يرجى التسجيل أولاً' : 'Please register first'));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
