import 'package:equatable/equatable.dart';

import 'about_us_model.dart';

abstract class AboutUsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AboutUsInitial extends AboutUsState {}

class AboutUsLoading extends AboutUsState {}

class AboutUsSuccess extends AboutUsState {
  final AboutUsModel aboutUs;
  AboutUsSuccess(this.aboutUs);

  @override
  List<Object?> get props => [aboutUs];
}

class AboutUsError extends AboutUsState {
  final String message;
  AboutUsError(this.message);

  @override
  List<Object?> get props => [message];
}