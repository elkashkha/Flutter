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
              return const Center(child: Text("لا توجد حجوزات نشطة"));
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

    final packageNames = booking.packages.isNotEmpty
        ? booking.packages.map((p) => p.nameAr).join(", ")
        : null;

    // جمع كل أسماء الـ Offers باستخدام Map بدل موديل
    final offerNames = booking.offers.isNotEmpty
        ? booking.offers.map((o) => o['title_ar'] ?? "لا يوجد").join(", ")
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 العميل: ${booking.user.name}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("✂️ الخدمة: $serviceNames"),
            if (packageNames != null) Text("📦 الباقة: $packageNames"),   
            if (offerNames != null) Text("🎁 العرض: $offerNames"),
            const SizedBox(height: 6),
            Text("⏰ ${booking.bookingDate} - ${booking.bookingTime}"),
            Text("💰 ${booking.totalPrice} KWT"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: MyCustomButton(
                    text: "تأكيد الحضور",
                    backgroundColor: Colors.green,
                    voidCallback: () {
                      context
                          .read<ActiveBookingCubit>()
                          .acceptBooking(booking.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم قبول الحجز ✅")),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyCustomButton(
                    text: "رفض",
                    backgroundColor: Colors.red,
                    voidCallback: () {
                      context
                          .read<ActiveBookingCubit>()
                          .rejectBooking(booking.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("تم رفض الحجز ❌")),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
