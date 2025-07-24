import 'package:elkashkha/features/booking/paymet_wepView.dart';
import 'package:elkashkha/features/booking/view_model/booking_cubit.dart';
import 'package:elkashkha/features/booking/view_model/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  List<String> selectedServiceIds = [];
  List<String> selectedServiceNames = [];
  List<String> selectedPackageIds = [];
  List<String> selectedPackageNames = [];
  String? selectedTeamId;
  String? selectedTeamName;
  List<String> selectedOfferIds = [];
  List<String> selectedOfferNames = [];
  List<String> selectedServicePrices = [];
  List<String> selectedPackageDiscountedPrices = [];
  List<String> selectedOfferDiscountedPrices = [];

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    context.read<ServicesCubit>().fetchServices();
    context.read<PackagesCubit>().fetchPackages();
    context.read<TeamCubit>().fetchTeamMembers();
    context.read<OffersCubit>().fetchOffers();
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
      selectedServiceIds = [];
      selectedServiceNames = [];
      selectedPackageIds = [];
      selectedPackageNames = [];
      selectedTeamId = null;
      selectedTeamName = null;
      selectedOfferIds = [];
      selectedOfferNames = [];
      selectedServicePrices = [];
      selectedPackageDiscountedPrices = [];
      selectedOfferDiscountedPrices = [];
      selectedDate = null;
      selectedTime = null;
    });
  }

  double calculateTotalAmount() {
    double total = 0.0;

    for (var price in selectedServicePrices) {
      total += double.tryParse(price) ?? 0.0;
    }

    for (var price in selectedPackageDiscountedPrices) {
      total += double.tryParse(price) ?? 0.0;
    }

    for (var price in selectedOfferDiscountedPrices) {
      total += double.tryParse(price) ?? 0.0;
    }

    return total;
  }

  String formatTimeForApi(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  void showSelectionBottomSheet({
    required BuildContext context,
    required String title,
    required List<dynamic> items,
    required List<String> selectedIds,
    required List<String> selectedNames,
    required List<String> selectedPrices,
    required String Function(dynamic) getName,
    required String Function(dynamic) getId,
    required String? Function(dynamic) getPrice,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final isSelected = selectedIds.contains(getId(item));
                        return CheckboxListTile(
                          title: Text(getName(item)),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                selectedIds.add(getId(item));
                                selectedNames.add(getName(item));
                                final price = getPrice(item);
                                if (price != null) {
                                  selectedPrices.add(price);
                                }
                              } else {
                                selectedIds.remove(getId(item));
                                selectedNames.remove(getName(item));
                                final price = getPrice(item);
                                if (price != null) {
                                  selectedPrices.remove(price);
                                }
                              }
                            });
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyCustomButton(
                    text: AppLocalizations.of(context)!.confirm,
                    voidCallback: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double padding = MediaQuery.of(context).size.width * 0.05;
    const double spacing = 16.0;
    final localizations = AppLocalizations.of(context)!;

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
          title: Text(localizations.booking_page),
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
                        return Text(localizations.failed_team);
                      }
                    },
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: nameController,
                    icon: Icons.person,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations.validate_name
                        : null,
                    hint: localizations.full_name,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: phoneController,
                    icon: Icons.phone,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations.validate_phone
                        : null,
                    hint: localizations.phone_number,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: emailController,
                    icon: Icons.email,
                    validate: (value) => value!.trim().isEmpty
                        ? localizations.enterYourEmail
                        : null,
                    hint: localizations.email,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: addressController,
                    icon: Icons.location_on,
                    hint: localizations.address,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: fullAddressController,
                    icon: Icons.location_city,
                    hint: localizations.full_address,
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<ServicesCubit, ServicesState>(
                    builder: (context, state) {
                      if (state is ServicesLoaded) {
                        return GestureDetector(
                          onTap: () {
                            showSelectionBottomSheet(
                              context: context,
                              title: localizations.choose_service,
                              items: state.services,
                              selectedIds: selectedServiceIds,
                              selectedNames: selectedServiceNames,
                              selectedPrices: selectedServicePrices,
                              getName: (service) =>
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          'ar'
                                      ? service.nameAr
                                      : service.nameEn,
                              getId: (service) => service.id.toString(),
                              getPrice: (service) => service.price?.toString(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppTheme.gray, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.grey.shade700,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedServiceNames.isEmpty
                                        ? localizations.choose_service
                                        : selectedServiceNames.join(', '),
                                    style: TextStyle(
                                      color: selectedServiceNames.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text(localizations.failed_services);
                    },
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<OffersCubit, OffersState>(
                    builder: (context, state) {
                      if (state is OffersLoaded) {
                        return GestureDetector(
                          onTap: () {
                            showSelectionBottomSheet(
                              context: context,
                              title: localizations.choose_offer,
                              items: state.offers,
                              selectedIds: selectedOfferIds,
                              selectedNames: selectedOfferNames,
                              selectedPrices: selectedOfferDiscountedPrices,
                              getName: (offer) =>
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          'ar'
                                      ? offer.titleAr
                                      : offer.titleEn,
                              getId: (offer) => offer.id.toString(),
                              getPrice: (offer) =>
                                  offer.discountedPrice?.toString(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppTheme.gray, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Colors.grey.shade700,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedOfferNames.isEmpty
                                        ? localizations.choose_offer
                                        : selectedOfferNames.join(', '),
                                    style: TextStyle(
                                      color: selectedOfferNames.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text(localizations.failed_offers);
                    },
                  ),
                  const SizedBox(height: spacing),
                  BlocBuilder<PackagesCubit, PackagesState>(
                    builder: (context, state) {
                      if (state is PackagesLoaded) {
                        return GestureDetector(
                          onTap: () {
                            showSelectionBottomSheet(
                              context: context,
                              title: localizations.choose_package,
                              items: state.packages,
                              selectedIds: selectedPackageIds,
                              selectedNames: selectedPackageNames,
                              selectedPrices: selectedPackageDiscountedPrices,
                              getName: (package) =>
                                  Localizations.localeOf(context)
                                              .languageCode ==
                                          'ar'
                                      ? package.nameAr
                                      : package.nameEn,
                              getId: (package) => package.id.toString(),
                              getPrice: (package) =>
                                  package.discountedPrice?.toString(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppTheme.gray, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.grey.shade700,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedPackageNames.isEmpty
                                        ? localizations.choose_package
                                        : selectedPackageNames.join(', '),
                                    style: TextStyle(
                                      color: selectedPackageNames.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Text(localizations.failed_packages);
                    },
                  ),
                  const SizedBox(height: spacing),
                  CustomTimePicker(
                    onTimeSelected: (time) {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    hintText: localizations.enter_time,
                  ),
                  const SizedBox(height: spacing),
                  EmailField(
                    taskController: noteController,
                    icon: Icons.note,
                    maxLines: 5,
                    hint: localizations.add_note,
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
                        Text(
                          localizations.total_amount,
                          style: const TextStyle(
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
                    listener: (context, state) {
                      print(
                          "📱 BookingCubitApi Listener triggered with state: ${state.runtimeType}");

                      if (state is BookingSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(localizations.booking_success),
                            backgroundColor: Colors.green,
                          ),
                        );

                        if (state.paymentUrl != null &&
                            state.paymentUrl!.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookingWebViewScreen(url: state.paymentUrl!),
                            ),
                          );
                        }

                        clearFields();
                      } else if (state is BookingFailure) {
                        print("❌ BookingCubitApi failed: ${state.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${localizations.error_occurred}: ${state.message}"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (state is BookingLoading) {
                        print("⏳ BookingCubitApi in progress...");
                      }
                    },
                    child: BlocBuilder<BookingCubitApi, BookingApiState>(
                      builder: (context, state) {
                        bool isLoading = state is BookingLoading;

                        return MyCustomButton(
                          voidCallback: isLoading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedDate == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text(localizations.error_date)),
                                      );
                                      return;
                                    }

                                    if (selectedTime == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(localizations
                                                .validate_time_empty)),
                                      );
                                      return;
                                    }

                                    if (selectedServiceIds.isEmpty &&
                                        selectedPackageIds.isEmpty &&
                                        selectedOfferIds.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(localizations
                                                .error_service_package_team)),
                                      );
                                      return;
                                    }

                                    double totalAmount = calculateTotalAmount();

                                    if (totalAmount <= 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(content: Text('')),
                                      );
                                      return;
                                    }

                                    print(
                                        "📤 Validation passed, sending booking...");
                                    print("💰 Total Amount: $totalAmount");
                                    print(
                                        "👥 Team ID: $selectedTeamId, Team Name: $selectedTeamName");

                                    final List<int> serviceIds =
                                        selectedServiceIds
                                            .map((id) => int.parse(id))
                                            .toList();
                                    final List<int> packageIds =
                                        selectedPackageIds
                                            .map((id) => int.parse(id))
                                            .toList();
                                    final List<int> offerIds = selectedOfferIds
                                        .map((id) => int.parse(id))
                                        .toList();

                                    await context
                                        .read<BookingCubitApi>()
                                        .createBooking(
                                          teamId: selectedTeamId != null
                                              ? int.parse(selectedTeamId!)
                                              : null,
                                          bookingDate: DateFormat('yyyy-MM-dd')
                                              .format(selectedDate!),
                                          bookingTime:
                                              DateFormat('HH:mm').format(
                                            DateTime(
                                                0,
                                                0,
                                                0,
                                                selectedTime!.hour,
                                                selectedTime!.minute),
                                          ),
                                          name: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          phone: phoneController.text.trim(),
                                          services: serviceIds.isNotEmpty
                                              ? serviceIds
                                              : null,
                                          packages: packageIds.isNotEmpty
                                              ? packageIds
                                              : null,
                                          offers: offerIds.isNotEmpty
                                              ? offerIds
                                              : null,
                                        );
                                  }
                                },
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(localizations.send),
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
