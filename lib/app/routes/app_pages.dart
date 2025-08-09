import 'package:demnaa_front/app/modules/adresse_search/bindings/adresse_search_binding.dart';
import 'package:get/get.dart';

// import '../modules/adresse_search/bindings/adresse_search_binding.dart';
// import '../modules/adresse_search/views/adresse_search_view.dart';
import '../modules/commande/bindings/commande_binding.dart';
import '../modules/commande/views/commande_view.dart';
import '../modules/create_favorite_place/bindings/create_favorite_place_binding.dart';
import '../modules/create_favorite_place/views/create_favorite_place_view.dart';
import '../modules/delivery/bindings/delivery_binding.dart';
import '../modules/delivery/views/delivery_view.dart';
import '../modules/delivery_tracking/bindings/delivery_tracking_binding.dart';
import '../modules/delivery_tracking/views/delivery_tracking_view.dart';
import '../modules/destination/bindings/destination_binding.dart';
import '../modules/destination/views/destination_view.dart';
import '../modules/driver_search/bindings/driver_search_binding.dart';
import '../modules/driver_search/views/driver_search_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/reverse_geocoding/bindings/reverse_geocoding_binding.dart';
import '../modules/reverse_geocoding/views/reverse_geocoding_view.dart';
import 'package:demnaa_front/app/modules/adresse_search/views/adresse_search_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY,
      page: () => const DeliveryView(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: _Paths.REVERSE_GEOCODING,
      page: () => ReverseGeocodingView(),
      binding: ReverseGeocodingBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_FAVORITE_PLACE,
      page: () => const CreateFavoritePlaceView(),
      binding: CreateFavoritePlaceBinding(),
    ),
    // GetPage(
    //   name: _Paths.COMMANDE,
    //   page: () => const CommandeView(),
    //   binding: CommandeBinding(),
    // ),
    GetPage(
      name: _Paths.ADRESSE_SEARCH,
      page: () => const AddressSearchView(),
      binding: AddressSearchBinding(),
    ),
    GetPage(
      name: _Paths.DELIVERY_TRACKING,
      page: () => const DeliveryTrackingView(),
      binding: DeliveryTrackingBinding(),
    ),
    GetPage(
      name: _Paths.DRIVER_SEARCH,
      page: () => const DriverSearchView(),
      binding: DriverSearchBinding(),
    ),
    GetPage(
      name: _Paths.DESTINATION,
      page: () => const DestinationView(),
      binding: DestinationBinding(),
    ),
  ];
}
