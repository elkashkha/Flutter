import 'package:elkashkha/features/booking/paymet_wepView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/emali_fild.dart';
import '../home_screen/presentation/views_model/offers/offers_cubit.dart';
import '../home_screen/presentation/views_model/offers/offers_state.dart';
import '../home_screen/presentation/views_model/services/service_cubit.dart';
import '../home_screen/presentation/views_model/services/service_state.dart';
import 'booking_api_cubit.dart';
import 'booking_api_state.dart';
import 'custom_date_picker.dart';
import '../home_screen/presentation/views_model/packages/packages_cubit.dart';
import '../home_screen/presentation/views_model/packages/packages_state.dart';
import '../profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import '../profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'custom_time_piker.dart';

class BookingService extends StatefulWidget {
  const BookingService({super.key});

  @override
  State<BookingService> createState() => _BookingServiceState();
}

class _BookingServiceState extends State<BookingService> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedServiceId;
  String? selectedServiceName;
  String? selectedPackageId;
  String? selectedPackageName;
  String? selectedTeamId;
  String? selectedTeamName;
  String? selectedOfferId;
  String? selectedOfferName;
  String? selectedServicePrice;
  String? selectedPackageDiscountedPrice;
  String? selectedOfferDiscountedPrice;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
    context.read<PackagesCubit>().fetchPackages();
    context.read<TeamCubit>().fetchTeamMembers();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    fullAddressController.dispose();
    noteController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    fullAddressController.clear();
    noteController.clear();
    emailController.clear();
    setState(() {
      selectedServiceId = null;
      selectedServiceName = null;
      selectedPackageId = null;
      selectedPackageName = null;
      selectedTeamId = null;
      selectedTeamName = null;
      selectedOfferId = null;
      selectedOfferName = null;
      selectedServicePrice = null;
      selectedPackageDiscountedPrice = null;
      selectedOfferDiscountedPrice = null;
      selectedDate = null;
      selectedTime = null;
    });
  }

  double calculateTotalAmount() {
    double total = 0.0;

    if (selectedServicePrice != null && selectedServicePrice!.isNotEmpty) {
      total += double.tryParse(selectedServicePrice!) ?? 0.0;
    }

    if (selectedPackageDiscountedPrice != null &&
        selectedPackageDiscountedPrice!.isNotEmpty) {
      total += double.tryParse(selectedPackageDiscountedPrice!) ?? 0.0;
    }

    if (selectedOfferDiscountedPrice != null &&
        selectedOfferDiscountedPrice!.isNotEmpty) {
      total += double.tryParse(selectedOfferDiscountedPrice!) ?? 0.0;
    }

    return total;
  }

  // Helper function to format TimeOfDay for API
  String formatTimeForApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  // Helper function to format TimeOfDay for display
  String formatTimeForDisplay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> sendWhatsAppMessage(
      BuildContext context, Map<String, dynamic> bookingData) async {
    print("📤 Starting sendWhatsAppMessage...");
    final localizations = AppLocalizations.of(context)!;

    String serviceName = selectedServiceName ?? 'غير محدد';
    String packageName = selectedPackageName ?? 'غير محدد';
    String teamName = selectedTeamName ?? 'غير محدد';
    String bookingDate = bookingData['booking_date']?.toString() ??
        selectedDate?.toString() ??
        'غير محدد';
    String bookingTime = bookingData['booking_time']?.toString() ??
        (selectedTime != null
            ? formatTimeForDisplay(selectedTime!)
            : 'غير محدد');
    String name = bookingData['name']?.toString() ?? nameController.text;
    String phone = bookingData['phone']?.toString() ?? phoneController.text;
    String address =
        addressController.text.isNotEmpty ? addressController.text : 'غير محدد';
    String fullAddress = fullAddressController.text.isNotEmpty
        ? fullAddressController.text
        : 'غير محدد';
    String note = noteController.text.isNotEmpty
        ? noteController.text
        : 'لا توجد ملاحظات';
    String status = bookingData['status']?.toString() ?? 'جديد';
    String bookingId = bookingData['id']?.toString() ?? 'غير معروف';
    String totalAmount = calculateTotalAmount().toString();

    String message = '''

📋 رقم الحجز: $bookingId
👤 الاسم: $name
📞 رقم الهاتف: $phone
🔧 الخدمة: $serviceName
📦 الباقة: $packageName
👥 الفريق: $teamName
🎁 العرض: $selectedOfferName
📅 التاريخ: $bookingDate
⏰ الوقت: $bookingTime
📝 الملاحظات: $note
💰 المبلغ الإجمالي: $totalAmount د.ك
🎁 العرض: $selectedOfferName

---
تم إرسال هذا الحجز تلقائياً من التطبيق
''';

    print("📤 Constructed WhatsApp message: $message");

    // Replace with your actual WhatsApp business number
    String phoneNumber = "+96555156388";
    phoneNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    print("📤 WhatsApp phone number: $phoneNumber");

    String encodedMessage = Uri.encodeComponent(message);
    String url = "https://wa.me/$phoneNumber?text=$encodedMessage";
    print("📤 WhatsApp URL length: ${url.length}");

    try {
      print("📤 Attempting to launch WhatsApp...");

      Uri whatsappUri = Uri.parse(url);
      bool canLaunch = await canLaunchUrl(whatsappUri);
      print("📤 Can launch WhatsApp: $canLaunch");

      if (canLaunch) {
        bool launched = await launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
        print("📤 WhatsApp launch result: $launched");

        if (launched) {
          print("✅ WhatsApp URL launched successfully");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم فتح واتساب بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('Failed to launch WhatsApp');
        }
      } else {
        throw Exception('WhatsApp is not available');
      }
    } catch (e) {
      print("❌ Error opening WhatsApp: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("خطأ في فتح واتساب: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = MediaQuery.of(context).size.width * 0.05;
    const double spacing = 16.0;
    final localizations = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ServicesCubit>(
          create: (context) => ServicesCubit()..fetchServices(),
        ),
        BlocProvider<PackagesCubit>(
          create: (context) => PackagesCubit()..fetchPackages(),
        ),
        BlocProvider<TeamCubit>(
          create: (context) => TeamCubit()..fetchTeamMembers(),
        ),
        BlocProvider<BookingCubitApi>(
          create: (context) => BookingCubitApi(),
        ),
        BlocProvider(create: (context) => OffersCubit()..fetchOffers()),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xfffcfcfc),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(localizations!.booking_page),
          backgroundColor: AppTheme.white,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(padding),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomDatePicker(
                    onDateSelected: (value) {
                      setState(() {
                        selectedDate = value;
                      });
                    },
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<TeamCubit, TeamState>(
                    builder: (context, state) {
                      if (state is TeamLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localizations.choose_the_team,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 100,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.teamMembers.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final team = state.teamMembers[index];
                                  final isSelected =
                                      selectedTeamId == team.id.toString();

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTeamId = team.id.toString();
                                        selectedTeamName =
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    'ar'
                                                ? team.nameAr
                                                : team.nameEn;
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 70,
                                          height: 70,
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                          child: ClipOval(
                                            child: Image.network(
                                              team.image,
                                              width: 64,
                                              height: 50,
                                              fit: BoxFit.contain,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.person),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  'ar'
                                              ? team.nameAr
                                              : team.nameEn,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.black
                                                : Colors.grey[600],
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (state is TeamLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Text(localizations!.failed_team);
                      }
                    },
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: nameController,
                    icon: Icons.person,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations!.validate_name
                        : null,
                    hint: localizations!.full_name,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: phoneController,
                    icon: Icons.phone,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations!.validate_phone
                        : null,
                    hint: localizations!.phone_number,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: emailController,
                    icon: Icons.email,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations!.enterYourEmail
                        : null,
                    hint: localizations!.email,
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, state) {
                      if (state is ServicesLoaded) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedServiceId,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.category,
                                color: Colors.grey.shade700,
                                size: 24.0,
                              ),
                            ),
                            hint: Text(localizations!.choose_service),
                            onChanged: (value) {
                              final service = state.services
                                  .firstWhere((s) => s.id.toString() == value);
                              setState(() {
                                selectedServiceId = value;
                                selectedServiceName =
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'ar'
                                        ? service.nameAr
                                        : service.nameEn;

                                selectedServicePrice =
                                    service.price?.toString();
                              });
                            },
                            items: state.services.map((service) {
                              return DropdownMenuItem(
                                value: service.id.toString(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'ar'
                                          ? service.nameAr
                                          : service.nameEn,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return Text(localizations!.failed_services);
                    },
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, state) {
                      if (state is OffersLoaded) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedOfferId,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 15,
                              ),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.local_offer,
                                color: Colors.grey.shade700,
                                size: 24.0,
                              ),
                            ),
                            hint: Text(localizations!.choose_offer),
                            onChanged: (value) {
                              final offer = state.offers
                                  .firstWhere((o) => o.id.toString() == value);
                              setState(() {
                                selectedOfferId = value;
                                selectedOfferName =
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'ar'
                                        ? offer.titleAr
                                        : offer.titleEn;

                                selectedOfferDiscountedPrice =
                                    offer.discountedPrice?.toString();

                                if (offer.package != null &&
                                    offer.package!.id != 0) {
                                  selectedOfferId = offer.id.toString();
                                  selectedOfferName =
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'ar'
                                          ? offer.titleAr
                                          : offer.titleEn;
                                } else {
                                  selectedOfferId = null;
                                  selectedOfferName = null;
                                }
                              });
                            },
                            items: state.offers.map((offer) {
                              return DropdownMenuItem(
                                value: offer.id.toString(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'ar'
                                          ? offer.titleAr
                                          : offer.titleEn,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return Text(localizations!.failed_offers);
                    },
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<PackagesCubit, PackagesState>(
                    builder: (context, state) {
                      if (state is PackagesLoaded) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: selectedPackageId,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 15),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.card_giftcard,
                                color: Colors.grey.shade700,
                                size: 24.0,
                              ),
                            ),
                            hint: Text(localizations!.choose_package),
                            onChanged: (value) {
                              final package = state.packages
                                  .firstWhere((p) => p.id.toString() == value);
                              setState(() {
                                selectedPackageId = value;
                                selectedPackageName =
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            'ar'
                                        ? package.nameAr
                                        : package.nameEn;

                                selectedPackageDiscountedPrice =
                                    package.discountedPrice?.toString();
                              });
                            },
                            items: state.packages.map((package) {
                              return DropdownMenuItem(
                                value: package.id.toString(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      Localizations.localeOf(context)
                                                  .languageCode ==
                                              'ar'
                                          ? package.nameAr
                                          : package.nameEn,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }
                      return Text(localizations!.failed_packages);
                    },
                  ),
                  const SizedBox(height: spacing),
                  CustomTimePicker(
                    onTimeSelected: (time) {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    hintText: localizations!.enter_time,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: noteController,
                    icon: Icons.note,
                    maxLines: 5,
                    hint: localizations!.add_note,
                  ),
                  const SizedBox(height: spacing),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'المبلغ الإجمالي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${calculateTotalAmount()} د.ك',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: spacing * 1.5),
                  BlocListener<BookingCubitApi, BookingApiState>(
                    listener: (context, state) async {
                      print(
                          "📱 BlocListener triggered with state: ${state.runtimeType}");

                      if (state is BookingSuccess) {
                        try {
                          // Show success message first
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localizations!.booking_success),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Send WhatsApp message
                          await sendWhatsAppMessage(context, state.data);
                          if (state.InvoiceURL != null &&
                              state.InvoiceURL!.isNotEmpty) {
                            final String url = state.InvoiceURL!;

                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookingWebViewScreen(url: url),
                                ),
                              );
                            }
                          }

                          // Clear fields after successful booking
                          clearFields();
                        } catch (e) {
                          print("❌ Error in booking success handling: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("خطأ أثناء معالجة الحجز: $e"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      } else if (state is BookingFailure) {
                        print("❌ Booking failed: ${state.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${localizations!.error_occurred}: ${state.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (state is BookingLoading) {
                        print("⏳ Booking in progress...");
                      }
                    },
                    child: BlocBuilder<BookingCubitApi, BookingApiState>(
                      builder: (context, state) {
                        bool isLoading = state is BookingLoading;

                        return MyCustomButton(
                          voidCallback: isLoading
                              ? null
                              : () async {
                                  print(
                                      "🔄 Button pressed, starting validation...");

                                  if (_formKey.currentState!.validate()) {
                                    if (selectedDate == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                localizations!.error_date)),
                                      );
                                      return;
                                    }

                                    if (selectedTime == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(localizations!
                                                .validate_time_empty)),
                                      );
                                      return;
                                    }

                                    if (selectedServiceId == null &&
                                        selectedPackageId == null &&
                                        selectedTeamId == null &&
                                        selectedOfferId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(localizations!
                                                .error_service_package_team)),
                                      );
                                      return;
                                    }

                                    // حساب المبلغ الإجمالي
                                    double totalAmount = calculateTotalAmount();

                                    if (totalAmount <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'يرجى اختيار خدمة أو باقة أو عرض صحيح')),
                                      );
                                      return;
                                    }

                                    print(
                                        "📤 Validation passed, sending booking...");
                                    print("💰 Total Amount: $totalAmount");

                                    final apiCubit =
                                        context.read<BookingCubitApi>();
                                    await apiCubit.createBooking(
                                      phone: phoneController.text.trim(),
                                      email: emailController.text.trim(),
                                      name: nameController.text.trim(),
                                      currency: 'KWD',
                                      amount: totalAmount.toString(),
                                    );
                                  }
                                },
                          text: isLoading
                              ? 'جاري الإرسال...'
                              : localizations!.send,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
