

  import 'package:elkashkha/features/home_screen/presentation/views_model/services/services_model.dart';

  abstract class ServicesState {}

  class ServicesInitial extends ServicesState {}

  class ServicesLoading extends ServicesState {}

  class ServicesLoaded extends ServicesState {
    final List<Service> services;
    ServicesLoaded(this.services);
  }

  class ServicesError extends ServicesState {
    final String message;
    ServicesError(this.message);
  }