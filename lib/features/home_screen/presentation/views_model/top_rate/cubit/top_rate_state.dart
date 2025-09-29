import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/top_rate_model.dart';

abstract class TopRatedSpecialistState {}

class TopRatedSpecialistInitial extends TopRatedSpecialistState {}

class TopRatedSpecialistLoading extends TopRatedSpecialistState {}

class TopRatedSpecialistSuccess extends TopRatedSpecialistState {
  final TopRatedSpecialist specialist;
  TopRatedSpecialistSuccess(this.specialist);
}

class TopRatedSpecialistFailure extends TopRatedSpecialistState {
  final String message;
  TopRatedSpecialistFailure(this.message);
}
