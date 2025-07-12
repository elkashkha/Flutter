import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/widgets/loading.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final String content;

  const ContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    );
  }
}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return BlocProvider(
      create: (context) => AboutUsCubit()..fetchAboutUs(),
      child: BlocBuilder<AboutUsCubit, AboutUsState>(
        builder: (context, state) {
          if (state is AboutUsLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is AboutUsSuccess) {
            final aboutUs = state.aboutUs;

            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleWidget(title: isArabic ? aboutUs.title.ar : aboutUs.title.en),
                  const SizedBox(height: 8),
                  ContentWidget(content: isArabic ? aboutUs.content.ar : aboutUs.content.en),
                ],
              ),
            );
          } else if (state is AboutUsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text('لم يتم تحميل البيانات بعد.'));
        },
      ),
    );
  }
}
