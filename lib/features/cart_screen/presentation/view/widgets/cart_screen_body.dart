import 'package:flutter/cupertino.dart';

import '../cart_screen.dart';
import 'cart_list.dart';

class CartScreenBody extends StatelessWidget {
  const CartScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Expanded(child: CartList())],
    );
  }
}
