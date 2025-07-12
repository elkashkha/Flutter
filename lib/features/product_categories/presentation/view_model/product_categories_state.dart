import 'package:elkashkha/features/product_categories/presentation/view_model/product_categories_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProductCategoriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProductCategoriesInitial extends ProductCategoriesState {}

class ProductCategoriesLoading extends ProductCategoriesState {}

class ProductCategoriesLoaded extends ProductCategoriesState {
  final List<ProductCategory> categories;

  ProductCategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ProductCategoriesError extends ProductCategoriesState {
  final String message;

  ProductCategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}
