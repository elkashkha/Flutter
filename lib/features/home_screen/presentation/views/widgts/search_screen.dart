import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../views_model/search_screen/search_cubit.dart';
import '../../views_model/search_screen/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.white,
          title: CustomAppBar(
            title: AppLocalizations.of(context)!.search_now,
            onBackPressed: () {
              context.push('/NavBarView');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 14.0, right: 9, left: 9),
          child: Column(
            children: [
              Row(
                children: [
                  Container(

                    decoration: BoxDecoration(
                      color: AppTheme.primary,

                      borderRadius: BorderRadius.circular(screenWidth * 0.02),

                    ),
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.07,
                    child: Icon(
                      Icons.search_off,
                      size: screenWidth * 0.08,
                      color: AppTheme.white,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (query) =>
                          searchCubit.searchServices(query),
                      decoration: InputDecoration(
                        hintText: localization.search_now,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchLoaded) {
                      return ListView.builder(
                        itemCount: state.services.length,
                        itemBuilder: (context, index) {
                          final service = state.services[index];
                          return ListTile(
                            title: Text(service.nameAr),
                            subtitle: Text(service.nameEn),
                            onTap: () {
                              context.push(
                                '/ServiceDetails',
                                extra: {
                                  'service': {
                                    'imageUrl': service.imageUrl,
                                    'name_ar': service.nameAr,
                                    'name_en': service.nameEn,
                                    'price': service.price,
                                    'rate': service.averageRating,
                                    'duration': service.duration,
                                    'description_ar': service.descriptionAr,
                                    'description_en': service.descriptionEn,
                                    'details': {
                                      'tools': service.details.tools,
                                      'staff': service.details.staff,
                                    },
                                    'reviews': service.reviews,
                                  },
                                },
                              );
                            },
                          );
                        },
                      );
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message));
                    } else {
                      return Center(
                        child: SvgPicture.asset(
                          'assets/images/undraw_the-search_cjxa (1) 2.svg',
                          width: 233,
                          height: 191,
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
