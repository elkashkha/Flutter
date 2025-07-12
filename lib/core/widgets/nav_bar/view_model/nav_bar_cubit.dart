
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeTab(int index, BuildContext context) {
    emit(index);



    }
  }

