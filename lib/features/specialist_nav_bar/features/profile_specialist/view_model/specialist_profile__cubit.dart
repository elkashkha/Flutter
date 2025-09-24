import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'specialist_profile__state.dart';

class SpecialistProfileCubit extends Cubit<SpecialistProfileState> {
  SpecialistProfileCubit() : super(SpecialistProfileInitial());
}
