import 'package:dio/dio.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamInitial());

  final Dio _dio = Dio();

  Future<void> fetchTeamMembers() async {
    emit(TeamLoading());

    try {
      final response = await _dio.get('https://api.alkashkhaa.com/public/api/teams');
      final List<dynamic> data = response.data['data'];
      final List<TeamMember> teamMembers = data.map((json) => TeamMember.fromJson(json)).toList();

      emit(TeamLoaded(teamMembers));
    } catch (e) {
      emit(TeamError("Failed to load team members: $e"));
    }
  }
}