import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageState {
  final String languageCode;

  LanguageState(this.languageCode);
}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageState('en'));

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
    emit(LanguageState(languageCode));
  }

  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage') ?? 'ar';

    if (savedLanguage != state.languageCode) {
      emit(LanguageState(savedLanguage));
    }
  }
}