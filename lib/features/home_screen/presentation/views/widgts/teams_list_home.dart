import 'package:elkashkha/features/home_screen/presentation/views/widgts/team_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/widgets/loading.dart';

class TeamsListHome extends StatelessWidget {
  const TeamsListHome({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(localization.specialists),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) => TeamCubit()..fetchTeamMembers(),
        child: BlocBuilder<TeamCubit, TeamState>(
          builder: (context, state) {
            if (state is TeamLoading) {
              return const Center(child: CustomDotsTriangleLoader());
            } else if (state is TeamLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(

                  itemCount: state.teamMembers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 200/110, //
                  ),
                  itemBuilder: (context, index) {
                    final member = state.teamMembers[index];
                    return TeamMemberCard(member: member);
                  },
                ),
              );
            } else if (state is TeamError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
