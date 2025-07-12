import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'offers_model.dart';
import 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  final Dio dio;

  OffersCubit({Dio? dioInstance})
      : dio = dioInstance ?? Dio(),
        super(OffersInitial());

  Future<void> fetchOffers() async {
    emit(OffersLoading());

    const url = 'https://api.alkashkhaa.com/public/api/offers';

    try {
      final response = await dio.get(url);

      if (response.data == null) {
        emit(OffersError("لا توجد بيانات من السيرفر"));
        return;
      }

      final List<Offer> offers = parseOffer(response.data['data'])
          .where((offer) => offer.status == "active")
          .toList();

      if (offers.isNotEmpty) {
        emit(OffersLoaded(offers));
      } else {
        emit(OffersError("لا توجد عروض متاحه"));
      }
    } catch (e) {
      emit(OffersError("حدث خطأ أثناء تحميل البيانات"));
    }
  }
}

List<Offer> parseOffer(List<dynamic> jsonList) {
  return jsonList.map((json) => Offer.fromJson(json)).toList();
}