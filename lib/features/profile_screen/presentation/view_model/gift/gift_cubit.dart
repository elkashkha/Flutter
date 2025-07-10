import 'package:elkashkha/features/profile_screen/presentation/view_model/gift/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gift_service.dart';
import 'gift_state.dart';

class PlatinumGiftCubit extends Cubit<PlatinumGiftState> {
  final GiftService giftService;

  PlatinumGiftCubit(this.giftService) : super(PlatinumGiftInitial());

  void fetchGift() async {
    emit(PlatinumGiftLoading());

    try {
      final data = await giftService.getPlatinumGift();
      emit(PlatinumGiftSuccess(data));
    } catch (e) {
      emit(PlatinumGiftError(e.toString()));
    }
  }
}