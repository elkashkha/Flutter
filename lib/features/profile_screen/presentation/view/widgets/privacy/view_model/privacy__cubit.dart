import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/privacy/view_model/privacy__state.dart';
import 'package:elkashkha/features/profile_screen/presentation/view/widgets/privacy/view_model/privacy_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';



class PoliciesCubit extends Cubit<PoliciesState> {
  PoliciesCubit() : super(PoliciesInitial());

  Future<void> fetchPolicies() async {
    emit(PoliciesLoading());
    try {
      var response = await Dio().get('https://api.alkashkhaa.com/public/api/policies');
      var policies = PoliciesResponse.fromJson(response.data).policies;
      emit(PoliciesLoaded(policies));
    } catch (e) {
      emit(PoliciesError("فشل تحميل البيانات: ${e.toString()}"));
    }
  }
}
