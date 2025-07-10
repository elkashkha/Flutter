import 'package:dio/dio.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/search_screen/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/services_model.dart';

class SearchCubit extends Cubit<SearchState> {
  final Dio dio;

  SearchCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(SearchInitial());

  Future<void> searchServices(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    try {
      final response = await dio
          .get('https://api.alkashkhaa.com/public/api/services');

      if (response.data == null) {
        emit(SearchError("لا توجد بيانات من السيرفر"));
        return;
      }


      final serviceResponse = ServiceResponse.fromMap(response.data);
      final services = serviceResponse.data;


      final filteredServices = services
          .where((service) =>
      service.nameAr.contains(query) || service.nameEn.contains(query))
          .toList();

      if (filteredServices.isNotEmpty) {
        emit(SearchLoaded(filteredServices));
      } else {
        emit(SearchError("لا توجد نتائج مطابقة"));
      }
    } catch (e) {
      emit(SearchError("حدث خطأ أثناء البحث"));
    }
  }
}
