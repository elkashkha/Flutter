

import 'package:elkashkha/features/specialist_nav_bar/features/profile_specialist/view_model/specialist_model.dart';

abstract class SpecialistState {}

class SpecialistInitial extends SpecialistState {}

class SpecialistLoading extends SpecialistState {}

class SpecialistLoaded extends SpecialistState {
  final SpecialistProfile profile;
  SpecialistLoaded(this.profile);
}

class SpecialistFailure extends SpecialistState {
  final String error;
  SpecialistFailure(this.error);
}
