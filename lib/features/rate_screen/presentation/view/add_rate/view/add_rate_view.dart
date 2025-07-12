import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../booking/booking_cubit.dart';
import '../../../../../home_screen/presentation/views_model/services/service_cubit.dart';
import '../../../../../home_screen/presentation/views_model/services/service_state.dart';
import '../view_model/add_rate_cubit.dart';
import '../view_model/add_rate_state.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final localization = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => ReviewCubit(),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.your_rating,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: AppTheme.primary,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    return RatingBar.builder(
                      initialRating: context.read<ReviewCubit>().selectedStars,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        context.read<ReviewCubit>().updateRating(rating);
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  localization.write_your_review,
                  style: GoogleFonts.tajawal(
                    textStyle: TextStyle(
                      fontSize: screenWidth * 0.05,
                      color: AppTheme.primary,
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    return TextField(
                      controller: context.read<ReviewCubit>().reviewController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                BlocBuilder<ServicesCubit, ServicesState>(
                  builder: (context, state) {
                    if (state is ServicesLoaded) {
                      return DropdownButtonFormField<String>(
                        hint: Text(localization.choose_service),
                        onChanged: (value) {
                          context.read<ReviewCubit>().updateSelectedService(value);
                        },
                        items: state.services.map((service) {
                          return DropdownMenuItem(
                            value: service.id.toString(),
                            child: Text(service.nameAr),
                          );
                        }).toList(),
                      );
                    }
                    return const Text('تعذر تحميل الخدمات');
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    if (state is ReviewSubmitting) {
                      return const CircularProgressIndicator();
                    }
                    return MyCustomButton(
                      text: localization.send,
                      voidCallback: () {
                        context.read<ReviewCubit>().submitReview();
                      },
                    );
                  },
                ),
                SizedBox(height: screenHeight * 0.02),
                BlocBuilder<ReviewCubit, ReviewState>(
                  builder: (context, state) {
                    if (state is ReviewError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (state is ReviewSubmitted) {
                      return Text(
                        localization.review_submitted_successfully,
                        style: const TextStyle(color: Colors.green),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
