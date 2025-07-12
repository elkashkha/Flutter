
import 'package:elkashkha/features/rate_screen/presentation/view_model/reviews_model.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewModel> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}