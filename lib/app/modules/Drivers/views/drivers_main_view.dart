import 'package:demnaa_front/app/modules/Drivers/views/dirvers_empty_view.dart';
import 'package:demnaa_front/app/modules/Drivers/views/drivers_listfull_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drivers_controller.dart';

class DriversMainView extends GetView<DriversController> {
  const DriversMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Si la liste est vide, afficher la vue vide
      if (controller.drivers.isEmpty && !controller.isLoading.value) {
        return const DriversEmptyView();
      } else {
        // Sinon afficher la liste complète
        return const DriversListFullView();
      }
    });
  }
}

// Exemple d'utilisation dans vos routes :
/*

Dans votre app_pages.dart, ajoutez :

GetPage(
  name: '/drivers',
  page: () => const DriversMainView(),
  binding: BindingsBuilder(() {
    Get.lazyPut<DriversController>(() => DriversController());
  }),
),

Pour tester les deux états :

1. État vide : 
   controller.drivers.clear();

2. État avec données :
   controller._loadDrivers();

*/