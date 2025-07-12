import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/slider/slider_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';


part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit() : super(SliderInitial());

  static SliderCubit get(context) => BlocProvider.of(context);

  final Dio dio = Dio();

  Future<void> fetchSliders() async {
    emit(SliderLoading());

    try {
      Response response = await dio.get(
        'https://api.alkashkhaa.com/public/api/sliders',
      );

      if (response.statusCode == 200) {
        SliderModel sliderModel = SliderModel.fromJson(response.data);
        emit(SliderLoaded(sliderModel));
      } else {
        emit(SliderError('حدث خطأ غير متوقع'));
      }
    } catch (e) {
      emit(SliderError('خطأ في الاتصال بالسيرفر: $e'));
    }
  }
}