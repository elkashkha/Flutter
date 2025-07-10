import 'package:dio/dio.dart';
import 'package:elkashkha/features/rate_screen/presentation/view_model/reviews_model.dart';
import 'package:elkashkha/features/rate_screen/presentation/view_model/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit() : super(ReviewsInitial());

  Future<void> fetchReviews() async {
    emit(ReviewsLoading());
    try {
      final response = await Dio().get('https://api.alkashkhaa.com/public/api/reviews');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final approvedReviews = data
            .where((review) => review['status'] == 'معتمد')
            .map((review) => ReviewModel.fromJson(review))
            .toList();
        emit(ReviewsLoaded(approvedReviews));
      } else {
        emit(ReviewsError('Failed to load reviews'));
      }
    } catch (e) {
      emit(ReviewsError('Failed to load reviews'));
    }
  }
}