import 'package:elkashkha/core/widgets/loading.dart';
import 'package:elkashkha/features/booking/paymet_wepView.dart';
import 'package:elkashkha/features/booking/view_model/booking_cubit.dart';
import 'package:elkashkha/features/booking/view_model/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../../../core/app_theme.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/emali_fild.dart';
import 'booking_api_cubit.dart';
import 'booking_api_state.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_date_picker.dart';
import 'widgets/booking_selection_container.dart';
import 'booking_summary_screen.dart';
import '../home_screen/presentation/views_model/offers/offers_cubit.dart';
import '../home_screen/presentation/views_model/offers/offers_state.dart';
import '../home_screen/presentation/views_model/packages/packages_cubit.dart';
import '../home_screen/presentation/views_model/packages/packages_state.dart';
import '../home_screen/presentation/views_model/services/service_cubit.dart';
import '../home_screen/presentation/views_model/services/service_state.dart';
import '../profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import '../profile_screen/presentation/view/widgets/about_us/view_model/teams_state.dart';
import 'custom_time_piker.dart';

class BookingSpecialist extends StatefulWidget {
  final int specialistId;
  final String level;
  final String overprice;
  final String specialistName;
  const BookingSpecialist(
      {super.key,
      required this.specialistId,
      required this.level,
      required this.overprice,
      required this.specialistName});

  @override
  State<BookingSpecialist> createState() => _BookingSpecialistState();
}

class _BookingSpecialistState extends State<BookingSpecialist> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<String> selectedServiceIds = [];
  List<String> selectedServiceNames = [];
  List<String> selectedPackageIds = [];
  List<String> selectedPackageNames = [];
  String? selectedTeamId;
  String? selectedTeamName;
  String? selectedOverprice; // جديد: لتخزين overprice الخاص بالـ specialist
  List<String> selectedOfferIds = [];
  List<String> selectedOfferNames = [];
  List<String> selectedServicePrices = [];
  List<String> selectedPackageDiscountedPrices = [];
  List<String> selectedOfferDiscountedPrices = [];

  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedOverprice = null; // تهيئة إلى null
    _loadUserData();
    context.read<ServicesCubit>().fetchServices();
    context.read<PackagesCubit>().fetchPackages();
    // context.read<SpecialistsCubit>().fetchSpecialists();
    context.read<OffersCubit>().fetchOffers();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('user_name') ?? '';
      emailController.text = prefs.getString('user_email') ?? '';
      phoneController.text = prefs.getString('user_phone') ?? '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    noteController.clear();
    emailController.clear();
    setState(() {
      selectedServiceIds = [];
      selectedServiceNames = [];
      selectedPackageIds = [];
      selectedPackageNames = [];
      selectedTeamId = null;
      selectedTeamName = null;
      selectedOverprice = null; // إعادة تهيئة إلى null
      selectedOfferIds = [];
      selectedOfferNames = [];
      selectedServicePrices = [];
      selectedDate = DateTime.now();
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

    total += double.tryParse(widget.overprice ?? '0') ?? 0.0;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
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
                          title: Text(
                            getName(item),
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                          ),
                          activeColor: const Color(0xff262626),
                          checkColor: Colors.white,
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
                    backgroundColor: const Color(0xff262626),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
        providers: [
          BlocProvider<ServicesCubit>(
            create: (context) => ServicesCubit()..fetchServices(),
          ),
          BlocProvider<PackagesCubit>(
            create: (context) => PackagesCubit()..fetchPackages(),
          ),
          BlocProvider<SpecialistsCubit>(
            create: (context) => SpecialistsCubit()..fetchSpecialists(),
          ),
          BlocProvider<BookingCubitApi>(
            create: (context) => BookingCubitApi(),
          ),
          BlocProvider(create: (context) => OffersCubit()..fetchOffers()),
        ],
        child: Scaffold(
          backgroundColor: isDark ? const Color(0xff151414) : const Color(0xff121212),
          appBar: AppBar(
            scrolledUnderElevation: 0,
            title: Text(
              localizations.booking_page,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: isDark ? const Color(0xff151414) : const Color(0xff121212),
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xff151414) : const Color(0xfffcfcfc),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
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
                      if (widget.overprice.isNotEmpty &&
                          widget.overprice != "0" &&
                          widget.overprice != "0.00")
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .specialist_fee(widget.overprice),
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, // ضيف حجم أكبر لو صغير جدًا
                                  ),
                                ),
                                const TextSpan(text: " "), // مسافة
                                TextSpan(
                                  text: widget.level,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // BlocBuilder<SpecialistsCubit, SpecialistsState>(
                      //   builder: (context, state) {
                      //     if (state is SpecialistsLoading) {
                      //       return const Center(child: CustomDotsTriangleLoader());
                      //     } else if (state is SpecialistsLoaded) {
                      //       final specialists = state.specialists;

                      //       return Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           Text(
                      //             localizations.choose_the_team,
                      //             style:
                      //                 const TextStyle(fontWeight: FontWeight.bold),
                      //           ),
                      //           const SizedBox(height: 8),
                      //           SizedBox(
                      //             height: 100,
                      //             child: ListView.separated(
                      //               scrollDirection: Axis.horizontal,
                      //               itemCount: specialists.length,
                      //               separatorBuilder: (_, __) =>
                      //                   const SizedBox(width: 12),
                      //               itemBuilder: (context, index) {
                      //                 final specialist = specialists[index];
                      //                 final isSelected = selectedTeamId ==
                      //                     specialist.id.toString();

                      //                 return GestureDetector(
                      //                   onTap: () {
                      //                     setState(() {
                      //                       selectedTeamId =
                      //                           specialist.id.toString();
                      //                       selectedTeamName =
                      //                           Localizations.localeOf(context)
                      //                                       .languageCode ==
                      //                                   'ar'
                      //                               ? specialist.name
                      //                               : specialist.name;
                      //                       selectedOverprice =
                      //                           specialist.overprice;
                      //                     });
                      //                   },
                      //                   child: Column(
                      //                     children: [
                      //                       Container(
                      //                         width: 70,
                      //                         height: 70,
                      //                         padding: const EdgeInsets.all(3),
                      //                         decoration: BoxDecoration(
                      //                           shape: BoxShape.circle,
                      //                           border: Border.all(
                      //                             color: isSelected
                      //                                 ? Colors.black
                      //                                 : Colors.grey,
                      //                             width: 2,
                      //                           ),
                      //                         ),
                      //                         child: ClipOval(
                      //                           child: Image.network(
                      //                             specialist.profilePicture,
                      //                             width: 64,
                      //                             height: 50,
                      //                             fit: BoxFit.contain,
                      //                             errorBuilder: (context, error,
                      //                                     stackTrace) =>
                      //                                 const Icon(Icons.person),
                      //                           ),
                      //                         ),
                      //                       ),
                      //                       const SizedBox(height: 4),
                      //                       Row(
                      //                         mainAxisSize: MainAxisSize.min,
                      //                         children: [
                      //                           Text(
                      //                             specialist.name,
                      //                             style: TextStyle(
                      //                               color: isSelected
                      //                                   ? Colors.black
                      //                                   : Colors.grey[600],
                      //                               fontWeight: isSelected
                      //                                   ? FontWeight.bold
                      //                                   : FontWeight.normal,
                      //                             ),
                      //                           ),
                      //                           const SizedBox(width: 4),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 );
                      //               },
                      //             ),
                      //           ),
                      //           const SizedBox(height: 8),

                      //           // ✅ يظهر فقط لو مش null ومش فاضي ومش 0
                      //           if (selectedOverprice != null &&
                      //               selectedOverprice!.isNotEmpty &&
                      //               selectedOverprice != "0")
                      //             Text.rich(
                      //               TextSpan(
                      //                 children: [
                      //                   TextSpan(
                      //                     text: AppLocalizations.of(context)!
                      //                         .specialist_fee(selectedOverprice!),
                      //                     style: const TextStyle(
                      //                       color: Colors.red,
                      //                       fontWeight: FontWeight.bold,
                      //                     ),
                      //                   ),
                      //                   const TextSpan(text: " "), // مسافة
                      //                   TextSpan(
                      //                     text: selectedTeamId != null
                      //                         ? specialists
                      //                             .firstWhere((s) =>
                      //                                 s.id.toString() ==
                      //                                 selectedTeamId)
                      //                             .level
                      //                         : "",
                      //                     style: const TextStyle(
                      //                       color: Colors.red,
                      //                       fontWeight: FontWeight.bold,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             )
                      //         ],
                      //       );
                      //     } else if (state is SpecialistsError) {
                      //       return Text(state.message);
                      //     } else {
                      //       return const SizedBox();
                      //     }
                      //   },
                      // ),
                      CustomTimePicker(
                        onTimeSelected: (time) {
                          setState(() {
                            selectedTime = time;
                          });
                        },
                        hintText: localizations.enter_time,
                      ),
                      const SizedBox(height: spacing),
                      Center(
                        child: Text(
                          localizations.choose_service_or_more,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<ServicesCubit, ServicesState>(
                        builder: (context, state) {
                          if (state is ServicesLoaded) {
                            return BookingSelectionContainer(
                              title: localizations.choose_service,
                              icon: Icons.category,
                              selectedNames: selectedServiceNames,
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
                                  getPrice: (service) =>
                                      service.price?.toString(),
                                );
                              },
                            );
                          }
                          return Text(localizations.failed_services);
                        },
                      ),
                      const SizedBox(height: spacing),
                      BlocBuilder<OffersCubit, OffersState>(
                        builder: (context, state) {
                          if (state is OffersLoaded &&
                              state.offers.isNotEmpty) {
                            return Column(
                              children: [
                                BookingSelectionContainer(
                                  title: localizations.choose_offer,
                                  icon: Icons.local_offer,
                                  selectedNames: selectedOfferNames,
                                  onTap: () {
                                    showSelectionBottomSheet(
                                      context: context,
                                      title: localizations.choose_offer,
                                      items: state.offers,
                                      selectedIds: selectedOfferIds,
                                      selectedNames: selectedOfferNames,
                                      selectedPrices:
                                      selectedOfferDiscountedPrices,
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
                                ),
                                const SizedBox(height: spacing),
                              ],
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      const SizedBox(height: spacing),
                      BlocBuilder<PackagesCubit, PackagesState>(
                        builder: (context, state) {
                          if (state is PackagesLoaded) {
                            return BookingSelectionContainer(
                              title: localizations.choose_package,
                              icon: Icons.card_giftcard,
                              selectedNames: selectedPackageNames,
                              onTap: () {
                                showSelectionBottomSheet(
                                  context: context,
                                  title: localizations.choose_package,
                                  items: state.packages,
                                  selectedIds: selectedPackageIds,
                                  selectedNames: selectedPackageNames,
                                  selectedPrices:
                                      selectedPackageDiscountedPrices,
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
                            );
                          }
                          return Text(localizations.failed_packages);
                        },
                      ),
                      const SizedBox(height: spacing * 1.5),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF222121) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizations.total_amount,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
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
                      MyCustomButton(
                        textColor: AppTheme.white,
                        backgroundColor: const Color(0xff262626),
                        voidCallback: () {
                          if (_formKey.currentState!.validate()) {
                            if (selectedDate == null) {
                              CherryToast.warning(
                                title: Text(localizations.error_date,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ).show(context);
                              return;
                            }

                            if (selectedTime == null) {
                              CherryToast.warning(
                                title: Text(localizations.validate_time_empty,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ).show(context);
                              return;
                            }

                            if (selectedServiceIds.isEmpty &&
                                selectedPackageIds.isEmpty &&
                                selectedOfferIds.isEmpty) {
                              CherryToast.warning(
                                title: Text(
                                    localizations.error_service_package_team,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ).show(context);
                              return;
                            }

                            double totalAmount = calculateTotalAmount();

                            if (totalAmount <= 0) {
                              CherryToast.warning(
                                title: const Text('Total amount cannot be zero',
                                    style: TextStyle(color: Colors.black)),
                              ).show(context);
                              return;
                            }

                            final List<int> serviceIds = selectedServiceIds
                                .map((id) => int.parse(id))
                                .toList();
                            final List<int> packageIds = selectedPackageIds
                                .map((id) => int.parse(id))
                                .toList();
                            final List<int> offerIds = selectedOfferIds
                                .map((id) => int.parse(id))
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingSummaryScreen(
                                  selectedDate: selectedDate!,
                                  selectedTime: selectedTime!,
                                  userName: nameController.text.trim(),
                                  userPhone: phoneController.text.trim(),
                                  userEmail: emailController.text.trim(),
                                  serviceNames: selectedServiceNames,
                                  serviceIds: serviceIds,
                                  packageNames: selectedPackageNames,
                                  packageIds: packageIds,
                                  offerNames: selectedOfferNames,
                                  offerIds: offerIds,
                                  specialistName: widget.specialistName,
                                  specialistId: widget.specialistId.toString(),
                                  totalAmount: totalAmount,
                                  bookingCubit: context.read<BookingCubitApi>(),
                                ),
                              ),
                            ).then((success) {
                              if (success == true) {
                                clearFields();
                              }
                            });
                          }
                        },
                        child: Text(
                          localizations.confirm_booking,
                          style: const TextStyle(
                              color: AppTheme.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
