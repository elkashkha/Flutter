import 'package:elkashkha/features/home_screen/presentation/views/widgts/team_list_card.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/widgets/loading.dart';

class SpecialistsView extends StatelessWidget {
  const SpecialistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecialistsCubit()..fetchSpecialists(),
      child: BlocBuilder<SpecialistsCubit, SpecialistsState>(
        builder: (context, state) {
          if (state is SpecialistsLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is SpecialistsLoaded) {
            return SizedBox(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.specialists.length,
                itemBuilder: (context, index) {
                  final specialist = state.specialists[index];
                  return SpecialistCard(specialist: specialist);
                },
              ),
            );
          } else if (state is SpecialistsError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
