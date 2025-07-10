import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_rate_state.dart';



class ReviewCubit extends Cubit<ReviewState> {
  ReviewCubit() : super(ReviewInitial());

  double selectedStars = 0.0;
  final TextEditingController reviewController = TextEditingController();
  String? selectedServiceId;

  void updateRating(double rating) {
    selectedStars = rating;
    emit(ReviewInitial());
  }

  void updateSelectedService(String? serviceId) {
    selectedServiceId = serviceId;
    emit(ReviewInitial());
  }

  Future<void> submitReview() async {
    if (selectedStars == 0 || reviewController.text.isEmpty || selectedServiceId == null) {
      emit(ReviewError('يرجى اختيار الخدمة، تحديد عدد النجوم، وكتابة رأيك'));
      return;
    }

    emit(ReviewSubmitting());

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      if (userId == null) {
        emit(ReviewError('لم يتم العثور على المستخدم'));
        return;
      }

      final response = await Dio().post(
        'https://api.alkashkhaa.com/public/api/reviews',
        data: {
          'user_id': userId,
          'service_id': selectedServiceId,
          'rating': selectedStars,
          'comment': reviewController.text,
        },
      );

      if (response.statusCode == 201) {
        emit(ReviewSubmitted());
        Future.microtask(() {
          resetReviewForm();
        });
      } else {
        emit(ReviewError('حدث خطأ أثناء إرسال التقييم'));
      }
    } catch (e) {
      emit(ReviewError('حدث خطأ أثناء الاتصال بالخادم: $e'));
    }
  }

  void resetReviewForm() {
    selectedStars = 0.0;
    selectedServiceId = null;
    reviewController.clear();
    emit(ReviewInitial());
  }
}
