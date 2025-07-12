// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class BookingState {
//   final String? name;
//   final String? phone;
//   final String? address;
//   final String? fullAddress;
//   final String? note;
//   final String? time;
//   final String? selectedServiceId;
//   final String? selectedServiceName;
//   final String? selectedPackageId;
//   final String? selectedPackageName;
//   final String? selectedTeamId;
//   final String? selectedTeamName;
//   final DateTime? selectedDate;
//
//   BookingState({
//     this.name,
//     this.phone,
//     this.address,
//     this.fullAddress,
//     this.note,
//     this.time,
//     this.selectedServiceId,
//     this.selectedServiceName,
//     this.selectedPackageId,
//     this.selectedPackageName,
//     this.selectedTeamId,
//     this.selectedTeamName,
//     this.selectedDate,
//   });
//
//   BookingState copyWith({
//     String? name,
//     String? phone,
//     String? address,
//     String? fullAddress,
//     String? note,
//     String? time,
//     String? selectedServiceId,
//     String? selectedServiceName,
//     String? selectedPackageId,
//     String? selectedPackageName,
//     String? selectedTeamId,
//     String? selectedTeamName,
//     DateTime? selectedDate,
//   }) {
//     return BookingState(
//       name: name ?? this.name,
//       phone: phone ?? this.phone,
//       address: address ?? this.address,
//       fullAddress: fullAddress ?? this.fullAddress,
//       note: note ?? this.note,
//       time: time ?? this.time,
//       selectedServiceId: selectedServiceId ?? this.selectedServiceId,
//       selectedServiceName: selectedServiceName ?? this.selectedServiceName,
//       selectedPackageId: selectedPackageId ?? this.selectedPackageId,
//       selectedPackageName: selectedPackageName ?? this.selectedPackageName,
//       selectedTeamId: selectedTeamId ?? this.selectedTeamId,
//       selectedTeamName: selectedTeamName ?? this.selectedTeamName,
//       selectedDate: selectedDate ?? this.selectedDate,
//     );
//   }
// }
//
// class BookingCubit extends Cubit<BookingState> {
//   BookingCubit() : super(BookingState());
//
//   void updateName(String value) => emit(state.copyWith(name: value));
//   void updatePhone(String value) => emit(state.copyWith(phone: value));
//   void updateAddress(String value) => emit(state.copyWith(address: value));
//   void updateTime(String value) => emit(state.copyWith(time: value));
//   void updateFullAddress(String value) => emit(state.copyWith(fullAddress: value));
//   void updateNote(String value) => emit(state.copyWith(note: value));
//
//   void updateSelectedService(String serviceId, String serviceName) {
//     emit(state.copyWith(
//       selectedServiceId: serviceId,
//       selectedServiceName: serviceName,
//     ));
//   }
//
//   void updateSelectedDate(DateTime value) => emit(state.copyWith(selectedDate: value));
//
//   void updateSelectedPackage(String? packageId, String? packageName) {
//     emit(state.copyWith(
//       selectedPackageId: packageId,
//       selectedPackageName: packageName,
//     ));
//   }
//
//   void updateSelectedTeam(String? teamId, String? teamName) {
//     emit(state.copyWith(
//       selectedTeamId: teamId,
//       selectedTeamName: teamName,
//     ));
//   }
//
//   void sendWhatsAppMessage(BuildContext context) async {
//     print("📞 Starting sendWhatsAppMessage...");
//     if (state.selectedServiceId == null || state.selectedServiceName == null) {
//       print("❌ selectedServiceId or selectedServiceName is null");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('يرجى اختيار الخدمة')),
//       );
//       return;
//     }
//
//     final String date = state.selectedDate != null
//         ? DateFormat('d/M/yyyy').format(state.selectedDate!)
//         : 'لم يتم اختيار تاريخ';
//
//     final String message = "📌 *تفاصيل الحجز:*\n"
//         "👤 *الاسم:* ${state.name ?? 'غير معروف'}\n"
//         "📞 *رقم الهاتف:* ${state.phone ?? 'غير محدد'}\n"
//         "📝 *ملاحظات:* ${state.note ?? 'لا يوجد'}\n"
//         "🛠 *الخدمة المطلوبة:* ${state.selectedServiceName ?? 'غير محدد'}\n"
//         "🎁 *الباقة:* ${state.selectedPackageName ?? 'غير محدد'}\n"
//         "👥 *الفريق:* ${state.selectedTeamName ?? 'غير محدد'}\n"
//         "📅 *التاريخ:* $date\n"
//         "⏰ *الوقت:* ${state.time ?? 'غير محدد'}";
//
//     final Uri url = Uri.parse(
//         'https://wa.me/96555156388?text=${Uri.encodeComponent(message)}');
//
//     print("📲 WhatsApp URL: $url");
//
//     try {
//       bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
//       if (!launched) {
//         print('❌ Failed to launch WhatsApp URL: $url');
//         launched = await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
//         if (!launched) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('تعذر فتح واتساب')),
//           );
//         } else {
//           print('✅ WhatsApp URL launched successfully in non-browser mode');
//         }
//       } else {
//         print('✅ WhatsApp URL launched successfully');
//       }
//     } catch (e) {
//       print('❌ Error launching WhatsApp: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('خطأ أثناء فتح واتساب')),
//       );
//     }
//   }
// }