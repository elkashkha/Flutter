import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../core/app_theme.dart';
import '../../../../../../../core/widgets/custom_button.dart';
import '../view_model/get_booking_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetBookingCubit()..getBookings(),
      child: const BookingTabs(),
    );
  }
}

class BookingTabs extends StatefulWidget {
  const BookingTabs({super.key});

  @override
  State<BookingTabs> createState() => _BookingTabsState();
}

class _BookingTabsState extends State<BookingTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildTab(String text, bool isSelected) {
    return Container(
      width: 163,
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الحجوزات"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          BlocBuilder<GetBookingCubit, GetBookingState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () => _tabController.animateTo(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: buildTab(
                        index == 0 ? "مكتمل" : "غير مكتمل",
                        _tabController.index == index,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<GetBookingCubit, GetBookingState>(
              builder: (context, state) {
                if (state is GetBookingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetBookingLoaded) {
                  final completedBookings =
                      state.bookings.where((b) => b.status == 'مكتمل').toList();
                  final notCompletedBookings =
                      state.bookings.where((b) => b.status != 'مكتمل').toList();

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      BookingList(bookingList: completedBookings),
                      BookingList(bookingList: notCompletedBookings),
                    ],
                  );
                } else if (state is GetBookingError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final List bookingList;
  const BookingList({super.key, required this.bookingList});

  @override
  Widget build(BuildContext context) {
    if (bookingList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/undraw_voting_3ygx 1.svg',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.no_bookings_now,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: bookingList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final booking = bookingList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            color: AppTheme.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: booking.service != null &&
                              booking.service.imageUrl.isNotEmpty
                          ? Image.network(
                              booking.service.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(booking.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('التاريخ: ${booking.bookingDate}'),
                        Text('الوقت: ${booking.bookingTime}'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text('الحالة: '),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: booking.status == 'مكتمل'
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(booking.status,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
