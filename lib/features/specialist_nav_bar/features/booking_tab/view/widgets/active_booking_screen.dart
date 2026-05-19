import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/active_booking_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/active_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/app_theme.dart';

class ActiveBookingScreen extends StatelessWidget {
  final bool isNested;
  const ActiveBookingScreen({super.key, this.isNested = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActiveBookingCubit()..fetchActiveBookings(),
      child: BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
        builder: (context, state) {
          if (state is ActiveBookingLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is ActiveBookingSuccess) {
            if (state.bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "لا توجد حجوزات نشطة",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: isNested,
              physics: isNested
                  ? const NeverScrollableScrollPhysics()
                  : const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: state.bookings.length,
              itemBuilder: (context, index) {
                final booking = state.bookings[index];
                return _buildBookingCard(context, booking);
              },
            );
          } else if (state is ActiveBookingError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final serviceNames = booking.services.isNotEmpty
        ? booking.services.map((s) => s.nameAr).join(", ")
        : "لا يوجد";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffE2E2E6), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Bar with calendar and date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xffF7F7F9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "اليوم ${booking.bookingDate}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          // Card Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // RTL align
              children: [
                // Client Name
                Text(
                  "اسم العميل : ${booking.user.name}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Service Type
                Text(
                  "نوع الخدمة : $serviceNames",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Price
                Text(
                  "المبلغ المستحق : ${booking.totalPrice ?? 0} دينار",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<ActiveBookingCubit>()
                                .rejectBooking(booking.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم إلغاء الحجز ❌")),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xffD92D20)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "إلغاء الحجز",
                            style: TextStyle(
                              color: Color(0xffD92D20),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<ActiveBookingCubit>()
                                .acceptBooking(booking.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("تم قبول الحجز ✅")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.black,
                          ),
                          child: const Text(
                            "تأكيد الحضور",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
