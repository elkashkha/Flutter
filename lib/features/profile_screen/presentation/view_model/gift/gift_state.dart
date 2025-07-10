import 'package:equatable/equatable.dart';
import 'model.dart';

abstract class PlatinumGiftState extends Equatable {
  @override
  List<Object> get props => [];
}

class PlatinumGiftInitial extends PlatinumGiftState {}

class PlatinumGiftLoading extends PlatinumGiftState {}

class PlatinumGiftSuccess extends PlatinumGiftState {
  final PlatinumGiftResponse gift;

  PlatinumGiftSuccess(this.gift);

  @override
  List<Object> get props => [gift];
}

class PlatinumGiftError extends PlatinumGiftState {
  final String message;

  PlatinumGiftError(this.message);

  @override
  List<Object> get props => [message];
}