import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view/widgets/active_booking_screen.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view/widgets/completed_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../../../core/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../home_screen_specialist/view/widgets/app_bar_specialist.dart';

class BookingSpecialistScreen extends StatelessWidget {
  const BookingSpecialistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BookingSpecialistTabs();
  }
}

class BookingSpecialistTabs extends StatefulWidget {
  const BookingSpecialistTabs({super.key});

  @override
  State<BookingSpecialistTabs> createState() => _BookingSpecialistTabsState();
}

class _BookingSpecialistTabsState extends State<BookingSpecialistTabs>
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
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.black : const Color(0xffE2E2E6),
          width: 1,
        ),
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const AppBarSpecialist(
              title: 'حجوزاتي',
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return GestureDetector(
                      onTap: () => _tabController.animateTo(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: buildTab(
                          index == 0 ? "قادمة" : "مكتملة",
                          _tabController.index == index,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ActiveBookingScreen(),
                  CompletedBookingScreen()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingSpecialistList extends StatelessWidget {
  final List specialists;
  const BookingSpecialistList({super.key, required this.specialists});

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
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
      itemCount: specialists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final specialist = specialists[index];
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
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("اسم المتخصص",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('التخصص: عظام'),
                        Text('الخبرة: 5 سنوات'),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text('الحالة: '),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text("متاح",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12)),
                              ),
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
