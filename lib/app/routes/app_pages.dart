import 'package:get/get.dart';

import '../modules/delivery/bindings/delivery_binding.dart';
import '../modules/delivery/views/delivery_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/reverse_geocoding/bindings/reverse_geocoding_binding.dart';
import '../modules/reverse_geocoding/views/reverse_geocoding_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY,
      page: () => const DeliveryView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.REVERSE_GEOCODING,
      page: () => const ReverseGeocodingView(),
      binding: ReverseGeocodingBinding(),
    ),
  ];
}
