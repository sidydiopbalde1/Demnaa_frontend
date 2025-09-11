import 'package:demnaa_front/app/modules/delivery_tracking/views/delivery_success_view.dart';
import 'package:demnaa_front/app/modules/delivery_tracking/views/final_delivery_tracking_view.dart';
import 'package:get/get.dart';

import '../modules/Account/bindings/account_binding.dart';
import '../modules/Account/views/account_view.dart';
import '../modules/Drivers/bindings/drivers_binding.dart';
import '../modules/Drivers/views/dirvers_empty_view.dart';
import '../modules/Drivers/views/drivers_listfull_view.dart';
import '../modules/Drivers/views/drivers_main_view.dart';
import '../modules/PaymentSelection/bindings/payment_selection_binding.dart';
import '../modules/PaymentSelection/views/payment_selection_view.dart';
import '../modules/Profil/bindings/profil_binding.dart';
import '../modules/Profil/views/profil_view.dart';
import '../modules/adresse_search/bindings/adresse_search_binding.dart';
import '../modules/adresse_search/views/adresse_search_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/splash_screen.dart';
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
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/demarage_view.dart';
import '../modules/home/views/home_view.dart';
import '../modules/motoTaxiOrder/bindings/moto_taxi_order_binding.dart';
import '../modules/motoTaxiOrder/views/moto_taxi_order_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/reverse_geocoding/bindings/reverse_geocoding_binding.dart';
import '../modules/reverse_geocoding/views/reverse_geocoding_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/contact_view.dart';
import '../modules/settings/views/langage_settings_view.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/settings/views/theme_settings_view.dart';

// import '../modules/Drivers/views/drivers_view.dart';
// import '../modules/auth/views/auth_view.dart';
// import '../modules/commande/bindings/commande_binding.dart';
// import '../modules/commande/views/commande_view.dart';
// import '../modules/settings/controllers/contact_controller.dart';
// import '../modules/settings/controllers/settings_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DEMARRAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DEMARRAGE,
      page: () => DemarageView(),
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
      preventDuplicates: true, // Éviter les doublons de page
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

    // ========================================================================
    // PAGES ACCOUNT & PROFIL - Mises à jour avec widgets réutilisables
    // ========================================================================
    GetPage(
      name: _Paths.ACCOUNT,
      page: () => const AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => const ProfilView(),
      binding: ProfilBinding(),
    ),

    // ========================================================================
    // PAGES DRIVERS - Nouvelles implémentations
    // ========================================================================
    GetPage(
      name: _Paths.DRIVERS,
      page: () =>
          const DriversMainView(), // Page principale qui gère les deux états
      binding: DriversBinding(),
    ),
    GetPage(
      name: _Paths.DRIVERS_EMPTY,
      page: () => const DriversEmptyView(), // Page vide spécifique
      binding: DriversBinding(),
    ),
    GetPage(
      name: _Paths.DRIVERS_LIST,
      page: () => const DriversListFullView(), // Page avec liste complète
      binding: DriversBinding(),
    ),

    // ========================================================================
    // PAGES À CRÉER (commentées pour éviter les erreurs)
    // ========================================================================
    // GetPage(
    //   name: _Paths.MODIFY_NUMBER,
    //   page: () => const ModifyNumberView(), // À créer
    //   binding: AccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.BECOME_DRIVER,
    //   page: () => const BecomeDriverView(), // À créer
    //   binding: AccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.BECOME_OWNER,
    //   page: () => const BecomeOwnerView(), // À créer
    //   binding: AccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.SETTINGS,
    //   page: () => const SettingsView(), // À créer
    //   binding: AccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.INFORMATIONS,
    //   page: () => const InformationsView(), // À créer
    //   binding: AccountBinding(),
    // ),
    // GetPage(
    //   name: _Paths.ADD_DRIVER,
    //   page: () => const AddDriverView(), // À créer
    //   binding: DriversBinding(),
    // ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.LANGUAGE_SETTINGS,
      page: () => const LanguageSettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.THEME_SETTINGS,
      page: () => const ThemeSettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.INFORMATIONS,
      page: () => const ContactView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.MOTO_TAXI_ORDER,
      page: () => const MotoTaxiOrderView(),
      binding: MotoTaxiOrderBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const SplashScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PAYMENT_SELECTION,
      page: () => const PaymentSelectionView(),
      binding: PaymentSelectionBinding(),
    ),
     GetPage(
      name: _Paths.FINAL_DELIVERY_TRACKING,
      page: () => const FinalDeliveryTrackingView(),
      binding: DeliveryTrackingBinding(),
    ),
     GetPage(
      name: _Paths.DELIVERY_SUCCESS,
      page: () => const DeliverySuccessView(),
      binding: DeliveryTrackingBinding(),
    ),
  ];
}
