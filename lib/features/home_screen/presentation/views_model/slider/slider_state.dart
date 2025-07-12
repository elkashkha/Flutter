part of 'slider_cubit.dart';

@immutable
abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderLoading extends SliderState {}

class SliderLoaded extends SliderState {
  final SliderModel sliderModel;
  SliderLoaded(this.sliderModel);
}

class SliderError extends SliderState {
  final String message;
  SliderError(this.message);
}