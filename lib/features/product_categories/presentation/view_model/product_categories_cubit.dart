import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/product_categories/presentation/view_model/product_categories_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_categories_state.dart';

class ProductCategoriesCubit extends Cubit<ProductCategoriesState> {
  final Dio dio;

  ProductCategoriesCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(ProductCategoriesInitial());

  Future<void> fetchProductCategories() async {
    emit(ProductCategoriesLoading());

    const url = 'https://api.alkashkhaa.com/public/api/product-categories';

    try {
      final response = await dio.get(url);

      final categoriesResponse = ProductCategoriesResponse.fromJson(response.data);
      final categories = categoriesResponse.data;

      if (categories.isNotEmpty) {
        emit(ProductCategoriesLoaded(categories));
      } else {
        emit(ProductCategoriesError("لا توجد تصنيفات لعرضها"));
      }
    } on DioException catch (dioError) {
      log('Dio error: ${dioError.message}', error: dioError);
      emit(ProductCategoriesError("حدث خطأ أثناء الاتصال بالسيرفر"));
    } catch (e) {
      log('Unexpected error: $e', error: e);
      emit(ProductCategoriesError("حدث خطأ غير متوقع"));
    }
  }
}
