import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'booking_api_cubit.dart';
import 'booking_api_state.dart';
import 'paymet_wepView.dart';

class BookingSummaryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final String userName;
  final String userPhone;
  final String userEmail;
  final List<String> serviceNames;
  final List<int> serviceIds;
  final List<String> packageNames;
  final List<int> packageIds;
  final List<String> offerNames;
  final List<int> offerIds;
  final String? specialistName;
  final String? specialistId;
  final double totalAmount;
  final BookingCubitApi bookingCubit;

  const BookingSummaryScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    required this.serviceNames,
    required this.serviceIds,
    required this.packageNames,
    required this.packageIds,
    required this.offerNames,
    required this.offerIds,
    this.specialistName,
    this.specialistId,
    required this.totalAmount,
    required this.bookingCubit,
  }) : super(key: key);

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  String paymentMethod = 'cash'; // Default to cash

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Formatting date and time
    final DateFormat dayFormat = DateFormat('d MMMM yyyy', locale);
    final String formattedDate = dayFormat.format(widget.selectedDate);
    final DateTime dt =
        DateTime(0, 0, 0, widget.selectedTime.hour, widget.selectedTime.minute);
    final String formattedTime = DateFormat('hh:mm a', locale).format(dt);

    // Combine selected items
    List<String> allItems = [];
    allItems.addAll(widget.serviceNames);
    allItems.addAll(widget.packageNames);
    allItems.addAll(widget.offerNames);
    final String itemsString = allItems.isEmpty ? '-' : allItems.join(', ');

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: widget.bookingCubit,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xff151414) : const Color(0xff121212),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            localizations.booking_summary,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: isDark ? const Color(0xff151414) : const Color(0xff121212),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xff151414) : const Color(0xfffcfcfc),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF222121) : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.transparent),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header (Black container)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xff262626) : const Color(0xff1a1a1a),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Text(
                              "${localizations.your_booking_date} : $formattedDate",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Body sections
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Section 1: User info
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2C2B2B) : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${localizations.full_name} : ${widget.userName}",
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                      const SizedBox(height: 6),
                                      Text(
                                          "${localizations.phone_number} : ${widget.userPhone}",
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Section 2: Booking info
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF2C2B2B) : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "${localizations.service_or_offer} : $itemsString",
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                      const SizedBox(height: 6),
                                      Text(
                                          "${localizations.team} : ${widget.specialistName ?? '-'}",
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                      const SizedBox(height: 6),
                                      Text(
                                          "${localizations.date} و ${localizations.time} : $formattedDate , $formattedTime",
                                          style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black)),
                                      const SizedBox(height: 6),
                                      Text(
                                          "${localizations.total_amount} : ${widget.totalAmount} ${localizations.currency ?? 'KD'}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Section 3: Payment
                                // Container(
                                //   width: double.infinity,
                                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey.shade100,
                                //     borderRadius: BorderRadius.circular(8),
                                //   ),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Text(localizations.payment_method_cash, style: const TextStyle(fontSize: 14)),
                                //       Radio(
                                //         value: 'cash',
                                //         groupValue: paymentMethod,
                                //         activeColor: Colors.black,
                                //         onChanged: (value) {},
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Submit Button
                BlocListener<BookingCubitApi, BookingApiState>(
                  listener: (context, state) {
                    if (state is BookingSuccess) {
                      CherryToast.success(
                        title: Text(localizations.booking_success,
                            style: const TextStyle(color: Colors.black)),
                      ).show(context);

                      if (state.paymentUrl != null &&
                          state.paymentUrl!.isNotEmpty) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingWebViewScreen(url: state.paymentUrl!),
                          ),
                        );
                      } else {
                        // Pop twice to return to home or original screen
                        Navigator.pop(context);
                        Navigator.pop(
                            context, true); // true indicates success to parent
                      }
                    } else if (state is BookingFailure) {
                      CherryToast.error(
                        title: Text(
                            "${localizations.error_occurred}: ${state.message}",
                            style: const TextStyle(color: Colors.black)),
                      ).show(context);
                    }
                  },
                  child: BlocBuilder<BookingCubitApi, BookingApiState>(
                    builder: (context, state) {
                      bool isLoading = state is BookingLoading;

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        child: MyCustomButton(
                          textColor: Colors.white,
                          text: localizations.complete_booking,
                          voidCallback: isLoading
                              ? null
                              : () async {
                                  await context
                                      .read<BookingCubitApi>()
                                      .createBooking(
                                        teamId: widget.specialistId != null
                                            ? int.parse(widget.specialistId!)
                                            : null,
                                        bookingDate: DateFormat('yyyy-MM-dd')
                                            .format(widget.selectedDate),
                                        bookingTime: DateFormat('HH:mm').format(
                                          DateTime(
                                              0,
                                              0,
                                              0,
                                              widget.selectedTime.hour,
                                              widget.selectedTime.minute),
                                        ),
                                        name: widget.userName,
                                        email: widget.userEmail,
                                        phone: widget.userPhone,
                                        services: widget.serviceIds.isNotEmpty
                                            ? widget.serviceIds
                                            : null,
                                        packages: widget.packageIds.isNotEmpty
                                            ? widget.packageIds
                                            : null,
                                        offers: widget.offerIds.isNotEmpty
                                            ? widget.offerIds
                                            : null,
                                      );
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : Text(
                                  localizations.complete_booking,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
