import 'package:elkashkha/features/home_screen/presentation/views/widgts/services/services_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/widgets/loading.dart';
import '../../../views_model/services/service_cubit.dart';
import '../../../views_model/services/service_state.dart';

class ListService extends StatelessWidget {
  const ListService({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ServicesCubit, ServicesState>(
      builder: (context, state) {
        if (state is ServicesLoading) {
          return const ShimmerListServiceLoader();
        } else if (state is ServicesError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: Colors.red)),
          );
        } else if (state is ServicesLoaded) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

          return  SizedBox(
            height: screenHeight * 0.38,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];

                final imageUrl = service.imageUrl.isNotEmpty
                    ? service.imageUrl
                    : 'https://cdn.vectorstock.com/i/1000v/97/22/no-picture-vector-739722.avif';

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _ZoomInOutAnimation(
                    child: ListServiceItem(
                      text: isArabic ? service.nameAr : service.nameEn,
                      imageUrl: imageUrl,
                      serviceId: service.id,
                      details: service.details,
                      textColor: Colors.black,
                      price: service.price,
                      rate: service.averageRating,
                      service: service,
                    ),
                  ),
                );
              },
            ),
          );

        }
        return const Center(child: Text('لا توجد بيانات متاحة'));
      },
    );
  }
}

class ShimmerListServiceLoader extends StatelessWidget {
  const ShimmerListServiceLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 15,
                        width: 100,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 12,
                        width: 60,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
class _ZoomInOutAnimation extends StatefulWidget {
  final Widget child;
  const _ZoomInOutAnimation({required this.child});

  @override
  State<_ZoomInOutAnimation> createState() => _ZoomInOutAnimationState();
}

class _ZoomInOutAnimationState extends State<_ZoomInOutAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
