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
    return BlocProvider(
      create: (context) => CartCubit(CartRepository(Dio()))..getCart(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(isArabic ? 'سلة التسوق' : 'Shopping Cart'),
        ),
        body: const CartScreenBody(),
      ),
    );
  }
}
