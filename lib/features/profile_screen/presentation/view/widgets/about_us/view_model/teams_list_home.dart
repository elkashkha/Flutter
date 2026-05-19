import 'package:elkashkha/features/home_screen/presentation/views/widgts/team_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../../core/widgets/custom_app_bar.dart';

import '../../../../../../../core/widgets/loading.dart';

class TeamsListHome extends StatelessWidget {
  const TeamsListHome({super.key});

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff151414) : Colors.white,
      appBar: CustomAppBar(
        title: localization.specialists,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocProvider(
        create: (context) => SpecialistsCubit()..fetchSpecialists(),
        child: BlocBuilder<SpecialistsCubit, SpecialistsState>(
          builder: (context, state) {
            if (state is SpecialistsLoading) {
              return const Center(child: CustomDotsTriangleLoader());
            } else if (state is SpecialistsLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: state.specialists.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                    childAspectRatio: 150 / 210,
                  ),
                  itemBuilder: (context, index) {
                    final specialist = state.specialists[index];
                    return SpecialistCard(specialist: specialist);
                  },
                ),
              );
            } else if (state is SpecialistsError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
