import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbank_marchantise_app/widgets/authentication.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'controllers/global-controller.dart';
import 'controllers/settings-controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(SettingsController()).onInit();
  runApp(FoodEx());
}

class FoodEx extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.put(GlobalController()).onInit();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodBank',
      theme: ThemeData(),
      home: Authentication(),
    );
  }
}
