import 'package:dio/dio.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart'
    show
        SpecialistsError,
        SpecialistsInitial,
        SpecialistsLoaded,
        SpecialistsLoading,
        SpecialistsState;
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecialistsCubit extends Cubit<SpecialistsState> {
  SpecialistsCubit() : super(SpecialistsInitial());

  final Dio _dio = Dio();

  Future<void> fetchSpecialists() async {
    emit(SpecialistsLoading());

    try {
      final response =
          await _dio.get('https://apiv2.alkashkhaa.com/public/api/specialists');

      final specialistsResponse = SpecialistsResponse.fromJson(response.data);
      final specialists = specialistsResponse.data;

      emit(SpecialistsLoaded(specialists));
    } catch (e) {
      emit(SpecialistsError("Failed to load specialists: $e"));
    }
  }
}
