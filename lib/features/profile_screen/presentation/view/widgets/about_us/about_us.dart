import 'package:elkashkha/core/app_router.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_cubit.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_state.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/about_us/view_model/teams_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/loading.dart';
import 'about_us_video.dart';
import 'about_us_content.dart';
import 'image_about.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.white,
        title:  CustomAppBar(
          title: AppLocalizations.of(context)!.about_us,

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: ImageAbout(),
                ),
              ),
              const SizedBox(height: 20),
              const AboutUsContent(),
              const SizedBox(height: 20),
          
              const Text(
                'لقطات حية من خدماتنا وأجواء الصالون. شاهد كيف نهتم بأدق التفاصيل لضمان تجربة استثنائية لك!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
          
          
              BlocBuilder<AboutUsCubit, AboutUsState>(
                builder: (context, state) {
                  if (state is AboutUsLoading) {
                    return const Center(child: CustomDotsTriangleLoader());
                  } else if (state is AboutUsSuccess) {
                    return SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: AboutUsVideo(videoUrl: state.aboutUs.video),
                    );
                  } else if (state is AboutUsError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("لم يتم العثور على بيانات."));
                },
              ),
              const Text(
                'فريق العمل :',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              const TeamsView(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyCustomButton(text: 'احجز موعدك الان', voidCallback: () { context.push('/BookingService'); },),
              )
            ],
          ),
        ),
      ),
    );
  }
}
