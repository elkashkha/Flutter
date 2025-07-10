import 'package:elkashkha/features/home_screen/presentation/views/widgts/package/package_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/packages/packages_cubit.dart';
import '../../../views_model/packages/packages_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PacageScreen extends StatelessWidget {
  const PacageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final screenHeight = mediaQuery.size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final localization = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffFCFCFC),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.white,
          title: CustomAppBar(
            title: localization.packages,
          ),
        ),
        body: BlocBuilder<PackagesCubit, PackagesState>(
          builder: (context, state) {
            if (state is PackagesLoading) {
              return ShimmerGridLoader(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              );
            } else if (state is PackagesError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)),
              );
            } else if (state is PackagesLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 600 ? 3 : 2,
                  crossAxisSpacing: screenWidth * 0.025,
                  mainAxisSpacing: screenWidth * 0.025,
                  mainAxisExtent: screenHeight * 0.35,
                ),
                itemCount: state.packages.length,
                itemBuilder: (context, index) {
                  final packages = state.packages[index];
                  return PackageListItem(package: packages);
                },
              );
            }
            return const Center(child: Text('لا توجد بيانات متاحة'));
          },
        ),
      ),
    );
  }
}

class ShimmerGridLoader extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const ShimmerGridLoader({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = screenWidth > 600 ? 6 : 4;

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 3 : 2,
        crossAxisSpacing: screenWidth * 0.025,
        mainAxisSpacing: screenWidth * 0.025,
        mainAxisExtent: screenHeight * 0.35,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 15,
                  width: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
