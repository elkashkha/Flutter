import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'packages_state.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/packages/packages_model.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final Dio dio;

  PackagesCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(PackagesInitial());

  Future<void> fetchPackages() async {
    emit(PackagesLoading());

    const url = 'https://api.alkashkhaa.com/public/api/packages?lang=ar';

    try {
      final response = await dio.get(url);

      final packageResponse = PackagesResponse.fromMap(response.data);
      final packages = packageResponse.data;

      if (packages.isNotEmpty) {
        emit(PackagesLoaded(packages));
      } else {
        emit(PackagesError("لا توجد باقات لعرضها"));
      }
    } on DioException catch (dioError) {
      emit(PackagesError("حدث خطأ أثناء الاتصال بالسيرفر"));
    } catch (e) {
      log('Unexpected error: $e', error: e);
      emit(PackagesError("حدث خطأ غير متوقع"));
    }
  }
}
