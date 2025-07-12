
import '../services/services_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Service> services;
  SearchLoaded(this.services);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}