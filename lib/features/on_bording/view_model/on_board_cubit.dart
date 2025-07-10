import 'package:flutter_bloc/flutter_bloc.dart';
import 'model.dart';


class OnBoardingCubit extends Cubit<int> {
  OnBoardingCubit() : super(0);

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  final List<OnBoardingModel> pages = [
    OnBoardingModel(
      image: 'assets/images/1.svg',
      titleKey: 'onboarding_1_title',
      descriptionKey: 'onboarding_1_description',
    ),
    OnBoardingModel(
      image: 'assets/images/2.svg',
      titleKey: 'onboarding_2_title',
      descriptionKey: 'onboarding_2_description',
    ),
    OnBoardingModel(
      image: 'assets/images/3.svg',
      titleKey: 'onboarding_3_title',
      descriptionKey: 'onboarding_3_description',
    ),
  ];


  void changePage(int index) {
    emit(index);
  }
}