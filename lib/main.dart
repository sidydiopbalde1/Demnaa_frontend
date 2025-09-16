import 'package:demnaa_front/app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les services
  await initServices();
  runApp(const MyApp());
}
Future<void> initServices() async {
  // Service d'authentification
  Get.put(AuthService(), permanent: true);
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Moto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false
    );
  }
}