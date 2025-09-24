import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

abstract class SpecialistsState {
  List<Object> get props => [];
}

class SpecialistsInitial extends SpecialistsState {}

class SpecialistsLoading extends SpecialistsState {}

class SpecialistsLoaded extends SpecialistsState {
  final List<Specialist> specialists;

  SpecialistsLoaded(this.specialists);

  @override
  List<Object> get props => [specialists];
}

class SpecialistsError extends SpecialistsState {
  final String message;

  SpecialistsError(this.message);

  @override
  List<Object> get props => [message];
}
