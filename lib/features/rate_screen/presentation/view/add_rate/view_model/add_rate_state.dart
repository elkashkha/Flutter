
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitted extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}
