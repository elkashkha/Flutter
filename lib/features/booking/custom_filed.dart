//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../home_screen/presentation/views_model/services/service_cubit.dart';
// import '../home_screen/presentation/views_model/services/service_state.dart';
// import 'booking_api_cubit.dart';
//
// class ServiceDropDownScreen extends StatefulWidget {
//   @override
//   _ServiceDropDownScreenState createState() => _ServiceDropDownScreenState();
// }
//
// class _ServiceDropDownScreenState extends State<ServiceDropDownScreen> {
//   final List<Service> selectedService;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ServicesCubit, ServicesState>(
//       builder: (context, state) {
//         if (state is ServicesLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is ServicesError) {
//           return Center(child: Text(state.message));
//         } else if (state is ServicesLoaded) {
//           final services = state.services;
//
//           if (services.isEmpty) {
//             return Center(child: Text("لا توجد خدمات متاحة"));
//           }
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Text(
//                 "نوع الخدمة",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               DropdownButton<Service>(
//                 isExpanded: true,
//                 value: selectedService,
//                 icon: const Icon(Icons.keyboard_arrow_down),
//                 underline: const SizedBox(),
//                 items: services.map((service) {
//                   return DropdownMenuItem<Service>(
//                     value: service,
//                     child: Text(service.nameAr),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedService = value;
//                     selectedSubService = null;
//                     context.read<BookingCubit>().updateSelectedService(
//                       serviceId: value?.id ?? "",
//                       serviceName: value?.nameAr ?? "",
//                     );
//                   });
//                 },
//               ),
//               const SizedBox(height: 16),
//
//               if (selectedService != null && selectedService!.subServices.isNotEmpty) ...[
//                 const Text(
//                   "الخدمة الفرعية",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 8),
//                 DropdownButton<SubServiceModel>(
//                   isExpanded: true,
//                   value: selectedSubService,
//                   icon: const Icon(Icons.keyboard_arrow_down),
//                   underline: const SizedBox(),
//                   items: selectedService!.subServices.map((subService) {
//                     return DropdownMenuItem<SubServiceModel>(
//                       value: subService,
//                       child: Text(subService.titleAr),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedSubService = value;
//                       context.read<BookingCubit>().updateSelectedService(
//                         serviceId: selectedService?.id ?? "",
//                         serviceName: "${selectedService?.nameAr} - ${value?.titleAr ?? ''}",
//                       );
//                     });
//                   },
//                 ),
//               ],
//             ],
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   }
// }
