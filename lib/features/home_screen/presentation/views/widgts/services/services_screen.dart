
import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../views_model/services/service_cubit.dart';
import '../../../views_model/services/service_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = MediaQuery.of(context).size.width>600?MediaQuery.of(context).size.width*.75:MediaQuery.of(context).size.width;
    final screenHeight = mediaQuery.size.height;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';


    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffFCFCFC),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: AppTheme.white,
            title:  CustomAppBar(title: AppLocalizations.of(context)!.our_services,),
          ),
          body:BlocBuilder<ServicesCubit, ServicesState>(
            builder: (context, state) {
              if (state is ServicesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ServicesError) {
                return Center(
                  child:
                  Text(state.message, style: const TextStyle(color: Colors.red)),
                );
              } else if (state is ServicesLoaded) {
                final isArabic = Localizations.localeOf(context).languageCode == 'ar';

                return GridView.builder(
                  shrinkWrap: true,

                  padding: const EdgeInsets.all(8.0),
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    mainAxisExtent:MediaQuery.of(context).size.width>600?420: 300,
                  ),
                  itemCount: state.services.length,
                  itemBuilder: (context, index) {
                    final service = state.services[index];

                    final imageUrl = service.imageUrl.isNotEmpty
                        ? service.imageUrl
                        : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif';

                    return ListServiceItem(
                      text: isArabic ? service.nameAr : service.nameEn,
                      imageUrl: service.imageUrl,
                      serviceId: service.id,
                      details: service.details,
                      textColor: Colors.black,
                      price: service.price,
                      rate: service.averageRating,
                      service: service,
                    );
                  },
                );
              }
              return const Center(child: Text('لا توجد بيانات متاحة'));
            },
          ),

        ),
      ),
    );
  }
}