import '../data/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}
class CheckoutSuccess extends CartState {
  final String InvoiceURL;

  CheckoutSuccess(this.InvoiceURL);

}

class CartSuccess extends CartState {
  final String message;
  CartSuccess(this.message);
}


class CartLoaded extends CartState {
  final CartModel cartData;
  CartLoaded(this.cartData);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
