import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../view_model/get_booking_cubit.dart';
import '../view_model/get_booking_state.dart';
import '../view_model/model.dart';

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

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff151414)
          : const Color(0xFF1E1E1E), // Dark top section background
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 1. Dark Custom Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      isArabic ? Icons.arrow_back : Icons.arrow_forward,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    isArabic ? 'حجوزاتي' : 'My Bookings',
                    style: GoogleFonts.tajawal(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 48), // Spacing to center the title
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 2. White Curved Container Body
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xff151414) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Column(
                    children: [
                      // Segmented Tab bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF222121) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              // Completed Tab ("مكتمل")
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _tabController.animateTo(0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _tabController.index == 0
                                          ? (isDark
                                              ? const Color(0xff262626)
                                              : Colors.black)
                                          : (isDark
                                              ? const Color(0xFF222121)
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isArabic ? 'مكتمل' : 'Completed',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _tabController.index == 0
                                            ? Colors.white
                                            : (isDark
                                                ? Colors.white38
                                                : Colors.grey.shade500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Upcoming Tab ("حديث")
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _tabController.animateTo(1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _tabController.index == 1
                                          ? (isDark
                                              ? const Color(0xff262626)
                                              : Colors.black)
                                          : (isDark
                                              ? const Color(0xFF222121)
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isArabic ? 'حديث' : 'Upcoming',
                                      style: GoogleFonts.tajawal(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _tabController.index == 1
                                            ? Colors.white
                                            : (isDark
                                                ? Colors.white38
                                                : Colors.grey.shade500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tabs list content
                      Expanded(
                        child: BlocBuilder<GetBookingCubit, GetBookingState>(
                          builder: (context, state) {
                            if (state is GetBookingLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color:
                                        isDark ? Colors.white : Colors.black),
                              );
                            } else if (state is GetBookingLoaded) {
                              final completedBookings = state.bookings
                                  .where((b) => b.status == 'مكتمل')
                                  .toList();
                              final upcomingBookings = state.bookings
                                  .where((b) => b.status != 'مكتمل')
                                  .toList();

                              return TabBarView(
                                controller: _tabController,
                                children: [
                                  BookingList(bookingList: completedBookings),
                                  BookingList(bookingList: upcomingBookings),
                                ],
                              );
                            } else if (state is GetBookingError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: GoogleFonts.tajawal(color: Colors.red),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookingList extends StatelessWidget {
  final List<Booking> bookingList;
  const BookingList({super.key, required this.bookingList});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (bookingList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/no_booking.svg',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 24),
              Text(
                isArabic ? 'لا يوجد حجوزات حالياً' : 'No Bookings Currently',
                style: GoogleFonts.tajawal(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isArabic
                    ? 'اكتشف خدماتنا وقم بحجز موعدك الأول الآن!'
                    : 'Discover our services and book your first appointment now!',
                style: GoogleFonts.tajawal(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      itemCount: bookingList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = bookingList[index];

        // Resolve item details (Service, Package or Offer)
        final List<String> itemNames = [];
        for (var s in booking.services) {
          itemNames.add(isArabic ? s.nameAr : s.nameEn);
        }
        for (var p in booking.packages) {
          itemNames.add(isArabic ? p.nameAr : p.nameEn);
        }
        for (var o in booking.offers) {
          itemNames.add(isArabic ? o.titleAr : (o.titleEn ?? o.titleAr));
        }

        // Fallback to single fields if lists are empty
        if (itemNames.isEmpty) {
          if (booking.service != null) {
            itemNames.add(
                isArabic ? booking.service!.nameAr : booking.service!.nameEn);
          }
          if (booking.package != null) {
            itemNames.add(
                isArabic ? booking.package!.nameAr : booking.package!.nameEn);
          }
          if (booking.offer != null) {
            itemNames.add(isArabic
                ? booking.offer!.titleAr
                : (booking.offer!.titleEn ?? booking.offer!.titleAr));
          }
        }

        final itemTitle = itemNames.isNotEmpty
            ? itemNames.join(' + ')
            : (booking.name ?? (isArabic ? 'حجز بدون اسم' : 'Unnamed Booking'));

        String imageUrl = '';
        if (booking.services.isNotEmpty) {
          imageUrl = booking.services.first.imageUrl;
        } else if (booking.packages.isNotEmpty) {
          imageUrl = booking.packages.first.imageUrl;
        } else if (booking.offers.isNotEmpty) {
          imageUrl = booking.offers.first.imageUrl;
        } else {
          if (booking.service != null) {
            imageUrl = booking.service!.imageUrl;
          } else if (booking.package != null) {
            imageUrl = booking.package!.imageUrl;
          } else if (booking.offer != null) {
            imageUrl = booking.offer!.imageUrl;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF222121) : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: isDark ? Colors.grey : Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge & Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xff262626) : Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      booking.status == 'مكتمل'
                          ? (isArabic ? 'مكتمل' : 'Completed')
                          : (isArabic ? 'حديث' : 'Upcoming'),
                      style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${booking.bookingDate} , ${booking.bookingTime}',
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title and Image Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      itemTitle,
                      style: GoogleFonts.tajawal(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 80,
                      height: 50,
                      color:
                          isDark ? const Color(0xFF2C2B2B) : Colors.grey[200],
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 80,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported,
                                      size: 24, color: Colors.grey),
                            )
                          : const Icon(Icons.image_not_supported,
                              size: 24, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // View Receipt Outlined Button
              GestureDetector(
                onTap: () => _showReceiptDialog(context, booking, isArabic),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2B2B) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade300),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isArabic ? 'عرض الايصال' : 'View Receipt',
                    style: GoogleFonts.tajawal(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showReceiptDialog(
      BuildContext context, Booking booking, bool isArabic) {
    final List<String> itemNames = [];
    for (var s in booking.services) {
      itemNames.add(isArabic ? s.nameAr : s.nameEn);
    }
    for (var p in booking.packages) {
      itemNames.add(isArabic ? p.nameAr : p.nameEn);
    }
    for (var o in booking.offers) {
      itemNames.add(isArabic ? o.titleAr : (o.titleEn ?? o.titleAr));
    }

    if (itemNames.isEmpty) {
      if (booking.service != null) {
        itemNames
            .add(isArabic ? booking.service!.nameAr : booking.service!.nameEn);
      }
      if (booking.package != null) {
        itemNames
            .add(isArabic ? booking.package!.nameAr : booking.package!.nameEn);
      }
      if (booking.offer != null) {
        itemNames.add(isArabic
            ? booking.offer!.titleAr
            : (booking.offer!.titleEn ?? booking.offer!.titleAr));
      }
    }

    final itemTitle = itemNames.isNotEmpty
        ? itemNames.join(' + ')
        : (booking.name ?? (isArabic ? 'حجز بدون اسم' : 'Unnamed Booking'));

    final priceString = booking.totalPrice != null
        ? '${booking.totalPrice} ${isArabic ? 'د.ك' : 'KD'}'
        : booking.service != null
            ? '${booking.service!.price} ${isArabic ? 'د.ك' : 'KD'}'
            : booking.package != null
                ? '${booking.package!.discountedPrice} ${isArabic ? 'د.ك' : 'KD'}'
                : booking.offer != null
                    ? '${booking.offer!.discountedPrice} ${isArabic ? 'د.ك' : 'KD'}'
                    : '-';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header / Title
              Text(
                isArabic ? 'تفاصيل الإيصال' : 'Receipt Details',
                style: GoogleFonts.tajawal(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 3,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white70 : Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // Card details
              _buildReceiptRow(context, isArabic ? 'رقم الحجز:' : 'Booking ID:',
                  '#${booking.id}', isArabic),
              _buildReceiptDivider(context),
              _buildReceiptRow(context, isArabic ? 'الاسم:' : 'Name:',
                  booking.name ?? '-', isArabic),
              _buildReceiptDivider(context),
              _buildReceiptRow(context, isArabic ? 'الهاتف:' : 'Phone:',
                  booking.phone ?? '-', isArabic),
              _buildReceiptDivider(context),
              _buildReceiptRow(
                  context,
                  isArabic ? 'البريد الإلكتروني:' : 'Email:',
                  booking.email ?? '-',
                  isArabic),
              _buildReceiptDivider(context),
              _buildReceiptRow(
                  context,
                  isArabic ? 'التاريخ والوقت:' : 'Date & Time:',
                  '${booking.bookingDate} - ${booking.bookingTime}',
                  isArabic),
              _buildReceiptDivider(context),

              // Dynamic list of items
              if (booking.services.isNotEmpty) ...[
                _buildReceiptRow(
                  context,
                  isArabic ? 'الخدمات المحجوزة:' : 'Booked Services:',
                  booking.services
                      .map((s) => isArabic ? s.nameAr : s.nameEn)
                      .join('\n• '),
                  isArabic,
                ),
                _buildReceiptDivider(context),
              ],
              if (booking.packages.isNotEmpty) ...[
                _buildReceiptRow(
                  context,
                  isArabic ? 'الباقات المحجوزة:' : 'Booked Packages:',
                  booking.packages
                      .map((p) => isArabic ? p.nameAr : p.nameEn)
                      .join('\n• '),
                  isArabic,
                ),
                _buildReceiptDivider(context),
              ],
              if (booking.offers.isNotEmpty) ...[
                _buildReceiptRow(
                  context,
                  isArabic ? 'العروض المحجوزة:' : 'Booked Offers:',
                  booking.offers
                      .map((o) =>
                          isArabic ? o.titleAr : (o.titleEn ?? o.titleAr))
                      .join('\n• '),
                  isArabic,
                ),
                _buildReceiptDivider(context),
              ],
              if (booking.services.isEmpty &&
                  booking.packages.isEmpty &&
                  booking.offers.isEmpty) ...[
                _buildReceiptRow(
                    context,
                    isArabic ? 'الخدمة / العرض:' : 'Service / Offer:',
                    itemTitle,
                    isArabic),
                _buildReceiptDivider(context),
              ],

              _buildReceiptRow(
                context,
                isArabic ? 'الأخصائي:' : 'Specialist:',
                booking.team?.name ?? (isArabic ? 'لا يوجد' : 'None'),
                isArabic,
              ),
              _buildReceiptDivider(context),
              if (booking.specialistLevel != null &&
                  booking.specialistLevel!.isNotEmpty) ...[
                _buildReceiptRow(
                  context,
                  isArabic ? 'تقييم الأخصائي:' : 'Specialist Level:',
                  booking.specialistLevel!,
                  isArabic,
                ),
                _buildReceiptDivider(context),
              ],
              _buildReceiptRow(
                context,
                isArabic ? 'طريقة الدفع:' : 'Payment Method:',
                booking.paymentMethod,
                isArabic,
              ),
              _buildReceiptDivider(context),
              _buildReceiptRow(
                context,
                isArabic ? 'رقم الفاتورة:' : 'Invoice ID:',
                booking.invoiceId ?? (isArabic ? 'لا يوجد' : 'None'),
                isArabic,
              ),
              _buildReceiptDivider(context),
              if (booking.overprice != null &&
                  double.tryParse(booking.overprice!) != 0.0) ...[
                _buildReceiptRow(
                  context,
                  isArabic ? 'سعر إضافي للأخصائي:' : 'Specialist Extra Fee:',
                  '${booking.overprice} ${isArabic ? 'د.ك' : 'KD'}',
                  isArabic,
                ),
                _buildReceiptDivider(context),
              ],
              _buildReceiptRow(
                context,
                isArabic ? 'السعر الإجمالي:' : 'Total Price:',
                priceString,
                isArabic,
                isBoldValue: true,
                valueColor: Colors.green.shade700,
              ),
              _buildReceiptDivider(context),
              _buildReceiptRow(
                context,
                isArabic ? 'الحالة:' : 'Status:',
                booking.status,
                isArabic,
                isBoldValue: true,
                valueColor:
                    booking.status == 'مكتمل' ? Colors.green : Colors.orange,
              ),

              const SizedBox(height: 32),
              // Close Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xff262626) : Colors.black,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isArabic ? 'إغلاق' : 'Close',
                    style: GoogleFonts.tajawal(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
      BuildContext context, String label, String value, bool isArabic,
      {bool isBoldValue = false, Color? valueColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.tajawal(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.tajawal(
                fontSize: 14,
                color: valueColor ?? (isDark ? Colors.white70 : Colors.black87),
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: isArabic ? TextAlign.left : TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      thickness: 1,
      height: 8,
    );
  }
}
