import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'about_us_model.dart';
import 'about_us_state.dart';

class AboutUsCubit extends Cubit<AboutUsState> {
  AboutUsCubit() : super(AboutUsInitial());

  Future<void> fetchAboutUs() async {
    emit(AboutUsLoading());
    try {
      var response =
          await Dio().get('https://api.alkashkhaa.com/public/api/about-us');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];

        if (data.isNotEmpty) {
          var aboutUsItem = data.first as Map<String, dynamic>;
          emit(AboutUsSuccess(AboutUsModel.fromJson(aboutUsItem)));
        } else {
          emit(AboutUsError('لم يتم العثور على بيانات.'));
        }
      } else {
        emit(AboutUsError('حدث خطأ في جلب البيانات.'));
      }
    } catch (e) {
      emit(AboutUsError('خطأ في الاتصال: $e'));
    }
  }
}
