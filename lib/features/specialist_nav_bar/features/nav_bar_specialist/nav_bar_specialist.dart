import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../../../core/app_theme.dart';
import '../../../../core/flutter_local_notifications/notification_page.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/nav_bar/view_model/nav_bar_cubit.dart';
import '../booking_tab/view/screens/booking_tab.dart';
import '../home_screen_specialist/view/screen/home_screen_specialist.dart';
import '../profile_specialist/view/screen/profile_specialist.dart';

class SpecialistNavBarView extends StatefulWidget {
  const SpecialistNavBarView({super.key});

  @override
  State<SpecialistNavBarView> createState() => _SpecialistNavBarViewState();
}

class _SpecialistNavBarViewState extends State<SpecialistNavBarView> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, checkInternetConnection);

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        showNoInternetDialog();
      } else {
        checkInternetConnection();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      showNoInternetDialog();
      return;
    }

    bool hasInternet = await _checkActualInternetConnection();
    if (!hasInternet) {
      showNoInternetDialog();
    }
  }

  Future<bool> _checkActualInternetConnection() async {
    try {
      final response =
          await http.get(Uri.parse('https://www.google.com')).timeout(
                const Duration(seconds: 5),
                onTimeout: () => http.Response('Timeout', 408),
              );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void showNoInternetDialog() {
    final screenSize = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;

    if (mounted && ModalRoute.of(context)?.isCurrent == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 350,
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Image.asset(
                    'assets/images/Animation - 1747816986527.gif',
                    height: 100,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    localization.no_internet_title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    localization.no_internet_message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyCustomButton(
                        borderColor: Colors.black,
                        fontSize: 12,
                        textColor: Colors.black,
                        width: screenSize.width * 0.3,
                        text: localization.retry,
                        backgroundColor: AppTheme.white,
                        voidCallback: () {
                          Navigator.pop(context);
                          context.go('/');
                        },
                      ),
                      const SizedBox(width: 8),
                      MyCustomButton(
                        fontSize: 14,
                        width: screenSize.width * 0.3,
                        text: localization.close,
                        backgroundColor: Colors.black,
                        voidCallback: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, int>(
        builder: (context, currentIndex) {
          return PopScope(
            canPop: false,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: IndexedStack(
                    index: currentIndex,
                    children: const [
                      HomeScreenSpecialist(),
                      BookingSpecialistScreen(),
                      NotificationsScreen(),
                      ProfileSpecialist(),
                    ],
                  ),
                ),
              
                // Custom Bottom Navigation Bar
                bottomNavigationBar: Container(
                  color: const Color(0xff0B0B0F),
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    left: false,
                    right: false,
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(4, (index) {
                          final isSelected = currentIndex == index;
                  
                          final icons = [
                            Icons.home,
                            Icons.bookmark_add,
                            Icons.notifications,
                            Icons.person,
                          ];
                  
                          return GestureDetector(
                            onTap: () {
                              context.read<BottomNavCubit>().changeTab(index);
                            },
                            child: SizedBox(
                              width: 70,
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  // Active Item
                                  if (isSelected)
                                    Positioned(
                                      top: -28,
                                      child: Transform.rotate(
                                        angle: 0.785398,
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xff0B0B0F,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                                blurRadius: 10,
                                                spreadRadius: 1,
                                                offset: const Offset(
                                                  0,
                                                  1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          child: Transform.rotate(
                                            angle: -0.785398,
                                            child: Center(
                                              child: Icon(
                                                icons[index],
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                  
                                  // Inactive Item
                                  if (!isSelected)
                                    Icon(
                                      icons[index],
                                      color: Colors.grey,
                                      size: 28,
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
