import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../views_model/offers/offers_cubit.dart';
import '../../../views_model/offers/offers_state.dart';
import 'offerlist_item.dart';

class OfferList extends StatelessWidget {
  const OfferList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<OffersCubit, OffersState>(
      builder: (context, state) {
        if (state is OffersLoading) {
          return SizedBox(
            height: screenHeight * 0.37,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight * 0.18,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 16,
                          width: 100,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 14,
                          width: 60,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is OffersError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is OffersLoaded) {
          return SizedBox(
            height: screenHeight * 0.37,
            child: _ZoomInOutAnimation(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: state.offers.length,
                itemBuilder: (context, index) {
                  final offer = state.offers[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OfferlistItem(offer: offer),
                  );
                },
              ),
            ),
          );
        }
        return const Center(child: Text('لا توجد بيانات متاحة'));
      },
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
