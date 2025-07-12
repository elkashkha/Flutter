import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:elkashkha/features/rate_screen/presentation/view_model/reviews_cubit.dart';
import 'package:elkashkha/features/rate_screen/presentation/view_model/reviews_state.dart';
import 'item_rate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ReviewsCubit>().fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<ReviewsCubit, ReviewsState>(
        builder: (context, state) {
          if (state is ReviewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ReviewsError) {
            return Center(child: Text('خطأ: ${state.message}'));
          } else if (state is ReviewsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                GestureDetector(
                  onTap: () {
                    context.push('/AddReviewScreen');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Text(
                      localization.add_your_review,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xff151414)),
                          color: Colors.white,
                        ),
                        child: const Icon(Icons.add,
                            color: Colors.black, size: 18),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (state.reviews.isEmpty)
                  const Center(child: Text('لا توجد اراء.'))
                else
                  ...state.reviews.map((review) => RateService(
                        name: review.user.name,
                        rating: review.rating,
                        comment: review.comment,
                        userImage: review.user.imageUrl,
                        reviewDate: review.createdAt.toString().split(' ')[0],
                      )),
              ],
            );
          }
          return const Center(child: Text('حدث خطأ غير متوقع!'));
        },
      ),
    );
  }
}
