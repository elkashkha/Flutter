
import '../packages/packages_model.dart';

abstract class PackagesState {}

 class PackagesInitial extends PackagesState {}

 class PackagesLoading extends PackagesState {}

 class PackagesLoaded extends PackagesState {
  final List<Package> packages;
  PackagesLoaded(this.packages);
}

 class PackagesError extends PackagesState {
  final String message;
  PackagesError(this.message);
}