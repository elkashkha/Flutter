import 'package:elkashkha/core/widgets/custom_button.dart';
import 'package:elkashkha/core/widgets/emali_fild.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/services/service_cubit.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/services/service_state.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/completed_booking_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/completed_booking_state.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/cubit/portfolio_cubit.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/cubit/cubit/cubit/portfolio_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkashkha/features/specialist_nav_bar/features/booking_tab/view_model/booking_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // لتنسيق التاريخ
import '../../../../../../core/app_theme.dart';

// ====== شاشة الحجوزات المكتملة ======
class CompletedBookingScreen extends StatelessWidget {
  const CompletedBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CompletedBookingCubit()..fetchCompletedBookings(),
      child: Scaffold(
        body: BlocBuilder<CompletedBookingCubit, CompletedBookingState>(
          builder: (context, state) {
            if (state is CompletedBookingLoading) {
              return const Center(child: CustomDotsTriangleLoader());
            } else if (state is CompletedBookingError) {
              return Center(child: Text(state.message));
            } else if (state is CompletedBookingSuccess) {
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
                        "لا توجد حجوزات مكتملة",
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
                padding: const EdgeInsets.all(12),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return _buildBookingCard(context, booking);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    String servicesText = booking.services.isNotEmpty
        ? booking.services.map((s) => s.nameAr).join(" ، ")
        : "لا توجد خدمات";

    String packagesText = booking.packages.isNotEmpty
        ? booking.packages.map((p) => p.nameAr).join(" ، ")
        : "";

    final offerNames = booking.offers.isNotEmpty
        ? booking.offers.map((o) => o['title_ar'] ?? "لا يوجد").join(", ")
        : null;

    final bool canAddNotes = !booking.addedToPortfolio;

    // Format all services, packages, and offers dynamically
    List<String> details = [];
    if (servicesText.isNotEmpty && servicesText != "لا توجد خدمات") {
      details.add(servicesText);
    }
    if (packagesText.isNotEmpty) {
      details.add(packagesText);
    }
    if (offerNames != null) {
      details.add(offerNames);
    }
    final fullServicesText = details.isNotEmpty ? details.join(" ، ") : "لا يوجد";

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
                  "نوع الخدمة : $fullServicesText",
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
                    // Left Button: Upload Photos / Add Notes
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: canAddNotes
                              ? () {
                                  _showPortfolioDialog(context, booking.id);
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: canAddNotes ? Colors.black : const Color(0xffE2E2E6),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: Colors.white,
                          ),
                          child: Text(
                            canAddNotes ? "اضافه الملاحظات" : "تم الاضافه",
                            style: TextStyle(
                              color: canAddNotes ? Colors.black : Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Right Button: Attended Status (Static/Non-clickable)
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xffE2E2E6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "تم الحضور",
                            style: TextStyle(
                              color: Color(0xff8E8E93),
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

  void _showPortfolioDialog(BuildContext context, int bookingId) {
    final completedBookingCubit = context.read<CompletedBookingCubit>();
    showDialog(
      context: context,
      builder: (ctx) => AddPortfolioDialog(
        bookingId: bookingId,
        completedBookingCubit: completedBookingCubit,
      ),
    );
  }
}

class AddPortfolioDialog extends StatefulWidget {
  final int bookingId;
  final CompletedBookingCubit completedBookingCubit;
  const AddPortfolioDialog({
    super.key,
    required this.bookingId,
    required this.completedBookingCubit,
  });

  @override
  State<AddPortfolioDialog> createState() => _AddPortfolioDialogState();
}

class _AddPortfolioDialogState extends State<AddPortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _descArController = TextEditingController();
  String? beforeImagePath;
  String? afterImagePath;
  int? selectedServiceId;
  String? selectedServiceName;
  DateTime? selectedDate;
  int? productsSold;
  int? extraServicesUsed;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PortfolioCubit>(create: (_) => PortfolioCubit()),
        BlocProvider<ServicesCubit>(
          create: (_) => ServicesCubit()..fetchServices(),
        ),
      ],
      child: BlocConsumer<PortfolioCubit, PortfolioState>(
        listener: (context, state) {
          if (state is PortfolioSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("✅ تم إضافة البورتفوليو بنجاح")),
            );
            widget.completedBookingCubit.fetchCompletedBookings();
          } else if (state is PortfolioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            backgroundColor: AppTheme.white,
            title: const Text("اضافة الملاحظات"),
            content: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: AppTheme.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmailField(
                          taskController: _nameArController,
                          hint: "الاسم (عربي)",
                          icon: Icons.title,
                          validate: (v) => v!.isEmpty ? "مطلوب" : null,
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 12),
                        EmailField(
                          taskController: _descArController,
                          hint: "الوصف (عربي)",
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),

                        const SizedBox(height: 16),

                        // const Text("قبل", textAlign: TextAlign.right),
                        // GestureDetector(
                        //   onTap: () async {
                        //     final XFile? image = await ImagePicker()
                        //         .pickImage(source: ImageSource.gallery);
                        //     if (image != null) {
                        //       setState(() => beforeImagePath = image.path);
                        //     }
                        //   },
                        //   child: customImagePickerTile(beforeImagePath),
                        // ),
                        // const SizedBox(height: 12),

                        // const Text("بعد", textAlign: TextAlign.right),
                        // GestureDetector(
                        //   onTap: () async {
                        //     final XFile? image = await ImagePicker()
                        //         .pickImage(source: ImageSource.gallery);
                        //     if (image != null) {
                        //       setState(() => afterImagePath = image.path);
                        //     }
                        //   },
                        //   child: customImagePickerTile(afterImagePath),
                        // ),
                        // const SizedBox(height: 16),

                        // 🏷️ فئة الخدمة
                        const Text("فئة الخدمة", textAlign: TextAlign.right),
                        BlocBuilder<ServicesCubit, ServicesState>(
                          builder: (context, state) {
                            if (state is ServicesLoaded) {
                              return GestureDetector(
                                onTap: () {
                                  showSingleSelectionBottomSheet(
                                    context: context,
                                    title: 'اختر الخدمة',
                                    items: state.services,
                                    onSelect: (service) {
                                      setState(() {
                                        selectedServiceId = service.id;
                                        selectedServiceName =
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    'ar'
                                                ? service.nameAr
                                                : service.nameEn;
                                      });
                                    },
                                  );
                                },
                                child: customSelectTile(
                                  selectedServiceName ?? 'فئة الخدمة',
                                  icon: Icons.category,
                                ),
                              );
                            }
                            return const Text('... جاري تحميل الخدمات');
                          },
                        ),
                        const SizedBox(height: 16),

                        // عدد المنتجات المباعة
                        // const Text("عدد المنتجات المباعة",
                        //     textAlign: TextAlign.right),
                        DropdownButtonFormField<int>(
                          value: productsSold,
                          hint: const Text("عدد المنتجات المباعة"),
                          items: List.generate(30, (index) => index + 1)
                              .map((value) => DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              productsSold = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // عدد الخدمات الإضافية المستخدمة
                        // const Text("عدد الخدمات الإضافية المستخدمة",
                        //     textAlign: TextAlign.right),
                        DropdownButtonFormField<int>(
                          value: extraServicesUsed,
                          hint: const Text("عدد الخدمات الإضافية المستخدمة"),
                          items: List.generate(30, (index) => index + 1)
                              .map((value) => DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(value.toString()),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              extraServicesUsed = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء"),
              ),
              MyCustomButton(
                text: "إضافة",
                voidCallback: () {
                  if (_formKey.currentState!.validate() &&
                      selectedServiceId != null) {
                    context.read<PortfolioCubit>().addPortfolio(
                          bookingId: widget.bookingId,
                          nameAr: _nameArController.text,
                          nameEn: _nameArController.text,
                          descAr: _descArController.text,
                          descEn: _descArController.text,
                          serviceId: selectedServiceId!,
                          productsSold: productsSold,
                          extraServicesUsed: extraServicesUsed,
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("يرجى ملء جميع الحقول المطلوبة"),
                      ),
                    );
                  }
                },
                isLoading: state is PortfolioLoading,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ],
          );
        },
      ),
    );
  }

  // 🎨 ويدجت مخصصة لاختيار الصور
  Widget customImagePickerTile(String? imagePath) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.gray, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              imagePath != null ? 'تم اختيار الصورة' : '',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.right,
            ),
          ),
          const Icon(Icons.add_photo_alternate, color: Colors.grey),
        ],
      ),
    );
  }

  // 🎨 ويدجت مخصصة لاختيار الخدمة
  Widget customSelectTile(String text, {required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.gray, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.arrow_drop_down, color: Colors.grey),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: text == 'فئة الخدمة' ? Colors.grey : Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Icon(icon, color: Colors.grey.shade700, size: 24.0),
        ],
      ),
    );
  }
}

void showSingleSelectionBottomSheet({
  required BuildContext context,
  required String title,
  required List<dynamic> items, // افترض أنها List<Service>
  required Function(dynamic) onSelect,
}) {
  showModalBottomSheet(
    context: context,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final service = items[index];
              final name = Localizations.localeOf(context).languageCode == 'ar'
                  ? service.nameAr
                  : service.nameEn;
              return ListTile(
                title: Text(name),
                onTap: () {
                  onSelect(service);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
