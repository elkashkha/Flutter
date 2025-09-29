import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/cubit/top_rate_state.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/top_rate_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class TopRatedSpecialistCubit extends Cubit<TopRatedSpecialistState> {
  TopRatedSpecialistCubit() : super(TopRatedSpecialistInitial());

  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://apitest.alkashkhaa.com/public/api/"),
  );

  Future<void> getTopRatedSpecialist() async {
    emit(TopRatedSpecialistLoading());
    try {
      final response = await _dio.get("specialists/top_rated");
      final data = response.data['data'];
      final specialist = TopRatedSpecialist.fromJson(data);

      emit(TopRatedSpecialistSuccess(specialist));
    } catch (e) {
      emit(TopRatedSpecialistFailure(e.toString()));
    }
  }
}
