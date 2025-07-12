import 'package:elkashkha/core/widgets/nav_bar/view/nav_bar.dart';
import 'package:elkashkha/features/home_screen/presentation/views/widgts/offers_list/offers_details.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/forget_password/views/forget_password_view.dart';
import '../features/authentication/forget_password/views/rest_password.dart';
import '../features/authentication/login/presentation/view/login_screen.dart';
import '../features/authentication/otp/otp_screen.dart';
import '../features/authentication/register/presentation/view/register_screen.dart';
import '../features/booking/booking.dart';
import '../features/cart_screen/presentation/view/cart_screen.dart';
import '../features/home_screen/presentation/views/widgts/offers_list/offers_screen.dart';
import '../features/home_screen/presentation/views/widgts/package/pacage_screen.dart';
import '../features/home_screen/presentation/views/widgts/package/package_details.dart';
import '../features/home_screen/presentation/views/widgts/search_screen.dart';
import '../features/home_screen/presentation/views/widgts/services/services_screen.dart';
import '../features/home_screen/presentation/views/widgts/teams_details.dart';
import '../features/home_screen/presentation/views/widgts/teams_list_home.dart';
import '../features/on_bording/view/on_board_view.dart';
import '../features/product_categories/presentation/view/product_categories_view.dart';
import '../features/product_categories/presentation/view/widgets/products/products_view.dart';
import '../features/product_categories/presentation/view/widgets/products/view_model/product_detaills.dart';
import '../features/profile_screen/presentation/view/widgets/about_us/about_us.dart';
import '../features/profile_screen/presentation/view/widgets/about_us/view_model/teams_model.dart';
import '../features/profile_screen/presentation/view/widgets/booking_screen/view/booking_screen.dart';
import '../features/profile_screen/presentation/view/widgets/contact_us/contact_us.dart';
import '../features/profile_screen/presentation/view/widgets/gift_screen.dart';
import '../features/profile_screen/presentation/view/widgets/privacy/view_model/privacy_view.dart';
import '../features/profile_screen/presentation/view/widgets/update_profile.dart';
import '../features/rate_screen/presentation/view/add_rate/view/add_rate_view.dart';
import '../features/rate_screen/presentation/view/rate_list.dart';
import '../features/service_details/presentation/view/service_details.dart';
import '../features/splash/view/splash_view.dart';
import 'flutter_local_notifications/notification_page.dart';

abstract class Approuter {
  static final router = GoRouter(
    routes: [

      GoRoute(
        path: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/OnBoardingView',
        builder: (context, state) => const OnBoardingView(),
      ),
      GoRoute(
        path: '/NavBarView',
        builder: (context, state) => const NavBarView(),
      ),
      GoRoute(
        path: '/RegisterScreen',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/OffersScreen',
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: '/GiftsScreen',
        builder: (context, state) => const GiftsScreen(),
      ),
      GoRoute(
        path: '/BookingsScreen',
        builder: (context, state) => const BookingsScreen(),
      ),
      GoRoute(
        path: '/team-details',
        name: 'teamDetails',
        builder: (context, state) {
          final member = state.extra as TeamMember;
          return TeamDetailsPage(member: member);
        },
      ),
      GoRoute(
        path: '/CartScreen',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/PacageScreen',
        builder: (context, state) => const PacageScreen(),
      ),
      GoRoute(
        path: '/ServicesScreen',
        builder: (context, state) => const ServicesScreen(),
      ),
      GoRoute(
        path: '/AddReviewScreen',
        builder: (context, state) => const AddReviewScreen(),
      ),
      GoRoute(
        path: '/SearchScreen',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/NotificationsScreen',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/LoginScreenView',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/ServiceDetails',
        builder: (context, state) => const ServiceDetails(),
      ),
      GoRoute(
        path: '/TeamsListHome',
        builder: (context, state) => const TeamsListHome(),
      ),
      GoRoute(
        path: '/ProductList',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final categoryId = extra?['categoryId'] as int? ?? 0;
          return ProductList(categoryId: categoryId);
        },
      ),


      GoRoute(
        path: '/OffersDetails',
        builder: (context, state) => const OffersDetails(),
      ),
      GoRoute(
        path: '/PoliciesView',
        builder: (context, state) => const PoliciesView(),
      ),
      GoRoute(
        path: '/UpdateProfile',
        builder: (context, state) => const UpdateProfile(),
      ),
      GoRoute(
        path: '/BookingService',
        builder: (context, state) =>  const BookingService(),
      ),
      GoRoute(
        path: '/AboutUs',
        builder: (context, state) => const AboutUs(),
      ),
      GoRoute(
        path: '/ContactUs',
        builder: (context, state) =>     const ContactUs(),
      ),
      GoRoute(
        path: '/ForgetPasswordBody',
        builder: (context, state) =>      const ForgetPasswordView(),
      ),
      GoRoute(
        path: '/RestPassword',
        builder: (context, state) =>      const RestPassword(),
      ),
      GoRoute(
        path: '/RateList',
        builder: (context, state) =>     const RateList(),
      ),
      GoRoute(
        path: '/productDetails',
        builder: (context, state) => const ProductDetails(),
      ),
      GoRoute(
        path: '/PackageDetails',
        builder: (context, state) => const PackageDetails(),
      ),
      GoRoute(
        path: '/ProductCategoriesView',
        builder: (context, state) => const ProductCategoriesView(),
      ),
      GoRoute(
        path: '/otpVerification',
        builder: (context, state) {
          final email = state.extra as String;
          return OtpVerificationScreen(email: email);
        },
      ),







    ],
  );
}