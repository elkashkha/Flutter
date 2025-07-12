import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/product_model.dart';
import 'package:elkashkha/features/product_categories/presentation/view/widgets/products/view_model/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final Dio dio;

  ProductCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(ProductInitial());

  Future<void> fetchProductsByCategory(int categoryId) async {

    emit(ProductLoading());

    final url = 'https://api.alkashkhaa.com/public/api/products?category_id=$categoryId';

    try {
      final response = await dio.get(url);

      final productResponse = ProductResponse.fromMap(response.data);
      final products = productResponse.products;

      if (products.isNotEmpty) {
        emit(ProductLoaded(products));
      } else {
        emit(ProductError("لا توجد منتجات متاحة لهذه الفئة"));
      }
    } on DioException catch (dioError) {
      log('Dio error: ${dioError.message}', error: dioError);
      emit(ProductError("حدث خطأ أثناء الاتصال بالسيرفر"));
    } catch (e) {
      log('Unexpected error: $e', error: e);
      emit(ProductError("حدث خطأ غير متوقع"));
    }
  }

}
