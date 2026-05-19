import 'package:elkashkha/features/cart_screen/presentation/view/widgets/cart_screen_body.dart';
import 'package:elkashkha/features/cart_screen/presentation/view_model/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../data/cart_repository.dart';

class CartScreen extends StatelessWidget {
  final bool isArabic;

  const CartScreen({super.key, this.isArabic = true});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => CartCubit(CartRepository(Dio()))..getCart(),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff151414) : const Color(0xFF1E1E1E), // Dynamic background for the top
        appBar: AppBar(
          backgroundColor: isDark ? const Color(0xff151414) : const Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            isArabic ? 'سلة التسوق' : 'Shopping Cart',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: const ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: CartScreenBody(),
          ),
        ),
      ),
    );
  }
}
