
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/privacy/view_model/privacy_model.dart';

abstract class PoliciesState  {
  @override
  List<Object> get props => [];
}

class PoliciesInitial extends PoliciesState {}

class PoliciesLoading extends PoliciesState {}

class PoliciesLoaded extends PoliciesState {
  final List<Policy> policies;

  PoliciesLoaded(this.policies);

  @override
  List<Object> get props => [policies];
}

class PoliciesError extends PoliciesState {
  final String message;

  PoliciesError(this.message);

  @override
  List<Object> get props => [message];
}
