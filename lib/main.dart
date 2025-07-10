import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:webview_flutter/webview_flutter.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';
import 'core/change_language_cubit/change_language_cubit.dart';
import 'core/flutter_local_notifications/flutter_local_notifications_service.dart';
import 'features/authentication/forget_password/view_model/forget_password_cubit.dart';
import 'features/authentication/login/presentation/view_model/login_cubit.dart';
import 'features/authentication/register/presentation/view_model/register_cubit.dart';
import 'features/home_screen/presentation/views_model/search_screen/search_cubit.dart';
import 'features/home_screen/presentation/views_model/services/service_cubit.dart';
import 'features/home_screen/presentation/views_model/offers/offers_cubit.dart';
import 'features/home_screen/presentation/views_model/packages/packages_cubit.dart';
import 'features/product_categories/presentation/view_model/product_categories_cubit.dart';
import 'features/profile_screen/presentation/view/widgets/about_us/view_model/about_us_cubit.dart';
import 'features/profile_screen/presentation/view/widgets/about_us/view_model/teams_cubit.dart';
import 'features/profile_screen/presentation/view_model/user_cubit.dart';
import 'features/rate_screen/presentation/view_model/reviews_cubit.dart';
import 'features/booking/booking_api_cubit.dart';
import 'features/booking/booking_cubit.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialization();

  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  } else if (Platform.isIOS) {
    WebViewPlatform.instance = WebKitWebViewPlatform();
  }

  final languageCubit = LanguageCubit();
  await languageCubit.loadSavedLanguage();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => languageCubit),
        BlocProvider(create: (context) => RegisterCubit()),
        // BlocProvider(create: (context) => BookingCubit()),
        BlocProvider(create: (context) => BookingCubitApi()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => ForgetPasswordCubit()),
        BlocProvider(create: (context) => ServicesCubit()..fetchServices()),
        BlocProvider(create: (context) => AboutUsCubit()..fetchAboutUs()),

        BlocProvider(create: (context) => OffersCubit()..fetchOffers()),
        BlocProvider(create: (context) => PackagesCubit()..fetchPackages()),
        BlocProvider(
            create: (context) =>
                ProductCategoriesCubit()..fetchProductCategories()),
        BlocProvider(create: (context) => UserCubit()..fetchUserProfile()),
        BlocProvider(create: (context) => ReviewsCubit()..fetchReviews()),
        BlocProvider(create: (context) => TeamCubit()..fetchTeamMembers()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LanguageCubit>().state.languageCode;

    return MaterialApp.router(
      theme: AppTheme.lightTheme,
      routerConfig: Approuter.router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(languageCode),
    );
  }
}
