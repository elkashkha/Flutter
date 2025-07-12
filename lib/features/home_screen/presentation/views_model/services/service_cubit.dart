import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/services/services_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final Dio dio;

  ServicesCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());

    const url = 'https://api.alkashkhaa.com/public/api/services';

    try {
      final response = await dio.get(url);
      final serviceResponse = ServiceResponse.fromMap(response.data);
      final services = serviceResponse.data;

      if (services.isNotEmpty) {
        emit(ServicesLoaded(services));
      } else {
        emit(ServicesError("لا توجد خدمات لعرضها"));
      }
    } on DioException catch (dioError) {
      emit(ServicesError("حدث خطأ أثناء الاتصال بالسيرفر"));
    } catch (e) {
      log('Unexpected error: ', );
      emit(ServicesError("حدث خطأ غير متوقع"));
    }
  }
}
