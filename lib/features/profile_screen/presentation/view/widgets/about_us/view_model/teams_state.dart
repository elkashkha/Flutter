import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';

abstract class TeamState  {
  @override
  List<Object> get props => [];
}

class TeamInitial extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final List<TeamMember> teamMembers;
  TeamLoaded(this.teamMembers);

  @override
  List<Object> get props => [teamMembers];
}

class TeamError extends TeamState {
  final String message;
  TeamError(this.message);

  @override
  List<Object> get props => [message];
}