import 'package:dio/dio.dart';
import 'package:elkashkha/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../view_model/gift/gift_cubit.dart';
import '../../view_model/gift/gift_service.dart';
import '../../view_model/gift/gift_state.dart';
import '../../view_model/gift/model.dart';
import 'gift_list_item.dart';

class GiftsListScreen extends StatelessWidget {
  const GiftsListScreen({super.key});


  Future<void> _openWhatsApp(String giftName, String giftDescription) async {
    const phoneNumber = '+96555156388';
    final message = 'لقد قمت بمطالبة الهدية:\nالاسم: $giftName\nالوصف: $giftDescription';
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlatinumGiftCubit(GiftService(Dio()))..fetchGift(),
      child: BlocBuilder<PlatinumGiftCubit, PlatinumGiftState>(
        builder: (context, state) {
          if (state is PlatinumGiftLoading) {
            return const Center(child: CustomDotsTriangleLoader());
          } else if (state is PlatinumGiftError) {
            return const Center(child: Text(''));
          } else if (state is PlatinumGiftSuccess) {
            final giftData = state.gift;

            if (giftData.gift == null || giftData.gift!.giftable == null) {
              return const Center(child: Text('لقد حصلت على هديتك بالفعل أو لا توجد بيانات متاحة'));
            }

            return GiftListItem(
              imageUrl: giftData.gift!.giftable!.image,
              titleAr: giftData.gift!.giftable!.nameAr,
              titleEn: giftData.gift!.giftable!.nameEn,
              canClaim: giftData.canClaim,
              onClaimPressed: () async {
                try {
                  await _openWhatsApp(
                    giftData.gift!.giftable!.nameAr,
                    giftData.gift!.giftable!.descriptionAr,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل فتح WhatsApp: $e')),
                  );
                }
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}