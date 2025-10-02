import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/cubit/top_rate_cubit.dart';
import 'package:elkashkha/features/home_screen/presentation/views_model/top_rate/cubit/top_rate_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBannerWidget extends StatelessWidget {
  const HomeBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TopRatedSpecialistCubit()..getTopRatedSpecialist(),
      child: BlocBuilder<TopRatedSpecialistCubit, TopRatedSpecialistState>(
        builder: (context, state) {
          if (state is TopRatedSpecialistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TopRatedSpecialistSuccess) {
            final specialist = state.specialist;

            // ✅ لو الرسالة من السيرفر هي "No specialists found this month"
            if (specialist.name == "No specialists found this month") {
              return const SizedBox.shrink();
            }

            return Container(
              width: 343,
              height: 108,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF888887),
                    Color(0xC9000000),
                    Color(0xC9000000),
                  ],
                  stops: [.0, 0.79, 1.0],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "الموظف المثالي لهذا الشهر :\n${specialist.name}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),

                  /// الصورة
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1 / 1, // تقدر تغير النسبة
                      child: Image.network(
                        specialist.profilePicture,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.person, size: 60),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is TopRatedSpecialistFailure) {
            // ✅ لو جالي 404 أو رسالة No specialists → اخفي البانر
            if (state.message
                    .toString()
                    .contains("No specialists found this month") ||
                state.message.toString().contains("404")) {
              return const SizedBox.shrink();
            }
            return Text("Error: ${state.message}");
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
