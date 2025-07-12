import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';

import '../../../../../../../core/widgets/loading.dart';
import '../../../../../../home_screen/presentation/views/widgts/team_list_card.dart';

class TeamsView extends StatelessWidget {
  const TeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamCubit()..fetchTeamMembers(),
      child: BlocBuilder<TeamCubit, TeamState>(
        builder: (context, state) {
          if (state is TeamLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is TeamLoaded) {
            return SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.teamMembers.length,
                itemBuilder: (context, index) {
                  final member = state.teamMembers[index];
                  return TeamMemberCard(member: member,);
                },
              ),
            );
          } else if (state is TeamError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
