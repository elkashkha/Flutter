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
                return const Center(child: Text("لا توجد حجوزات مكتملة"));
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

    String offersText =
        booking.offers.isNotEmpty ? booking.offers.join(" ، ") : "";

    return GestureDetector(
      onTap: () {
        _showPortfolioDialog(context, booking.id);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text("💰 السعر: ${booking.totalPrice} KWT"),
              Text("📅 التاريخ: ${booking.bookingDate}"),
              const SizedBox(height: 6),
              Text("🛠️ الخدمة: $servicesText"),
              if (packagesText.isNotEmpty) Text("📦 الباقه: $packagesText"),
              if (offersText.isNotEmpty) Text("🎁 عرض: $offersText"),
              const SizedBox(height: 6),
              MyCustomButton(
                text: "اضافه الملاحظات",
                voidCallback: () {
                  _showPortfolioDialog(context, booking.id);
                },
                isLoading: false, // هنا مفيش loading لأنه مجرد فتح الدايـلوج
                backgroundColor: Colors.black,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPortfolioDialog(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AddPortfolioDialog(bookingId: bookingId),
    );
  }
}

class AddPortfolioDialog extends StatefulWidget {
  final int bookingId;
  const AddPortfolioDialog({super.key, required this.bookingId});

  @override
  State<AddPortfolioDialog> createState() => _AddPortfolioDialogState();
}

class _AddPortfolioDialogState extends State<AddPortfolioDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _descArController = TextEditingController();
  final _descEnController = TextEditingController();
  String? beforeImagePath;
  String? afterImagePath;
  int? selectedServiceId;
  String? selectedServiceName;
  DateTime? selectedDate;

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
          } else if (state is PortfolioError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            backgroundColor: AppTheme.white,
            title: const Text("اضافة صور"),
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
                        EmailField(
                          taskController: _nameEnController,
                          hint: "الاسم (إنجليزي)",
                          icon: Icons.title,
                          validate: (v) => v!.isEmpty ? "مطلوب" : null,
                        ),
                        const SizedBox(height: 12),
                        EmailField(
                          taskController: _descArController,
                          hint: "الوصف (عربي)",
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 12),
                        EmailField(
                          taskController: _descEnController,
                          hint: "الوصف (إنجليزي)",
                          icon: Icons.description,
                          maxLines: 3,
                        ),
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
                          nameEn: _nameEnController.text,
                          descAr: _descArController.text,
                          descEn: _descEnController.text,
                          serviceId: selectedServiceId!,
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
