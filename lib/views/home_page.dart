import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodbank_marchantise_app/controllers/global-controller.dart';
import 'package:foodbank_marchantise_app/controllers/notification_order_controller.dart';
import 'package:foodbank_marchantise_app/utils/images.dart';
import 'package:foodbank_marchantise_app/utils/size_config.dart';
import 'package:foodbank_marchantise_app/utils/theme_colors.dart';
import 'package:foodbank_marchantise_app/widgets/order_list_pending.dart';
import 'package:foodbank_marchantise_app/widgets/shimmer/home_page_shimmer.dart';
import 'package:get/get.dart';
import 'no_order_order_history.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  //int status=1;
  final order_Controller = Get.put(OrderListController());
  final settingController = Get.put(GlobalController());

  @override
  void initState() {
    order_Controller.onInit();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print('getInitialMessage data: ${message!.data}');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      order_Controller.onInit();
      print("onMessage data: ${message.data}");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
    });
    FirebaseMessaging.instance.getToken().then((token) {
      update(token!);
    });
    super.initState();
  }

  update(String token) async {
    setState(() {
      settingController.updateFCMToken(token);
    });
  }

  Future<Null> _refresh() async {
    print('refreshing stocks...');
    order_Controller.onInit();
    await Future.delayed(new Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);

    return GetBuilder<OrderListController>(
      init: OrderListController(),
      builder: (orders) => orders.loader
          ? HomePageShimmer()
          : Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: ThemeColors.baseThemeColor,
                foregroundColor: Colors.white,
                centerTitle: true,
                title: settingController.siteName == null
                    ? Text("Welcome")
                    : Text(
                        '${settingController.siteName}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
              ),
              body: RefreshIndicator(
                onRefresh: _refresh,
                child: orders.orderList.length > 0
                    ? Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[Orders()],
                      )
                    : NoOrderFoundOrderHistory("No order", Images.noOrderFound),
              )),
    );
  }
}
