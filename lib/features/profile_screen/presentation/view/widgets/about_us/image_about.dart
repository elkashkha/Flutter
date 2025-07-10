import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/loading.dart';
import 'image_about_us.dart';

class ImageAbout extends StatelessWidget {
  const ImageAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AboutUsCubit()..fetchAboutUs(),
      child: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          if (state is AboutUsLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is AboutUsSuccess) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ImageGrid(imageUrls: state.aboutUs.images),
            );
          } else if (state is AboutUsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text('لم يتم تحميل البيانات بعد.'));
        },
      )
      );
  }
}
