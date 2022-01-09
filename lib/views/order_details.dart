import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodbank_marchantise_app/controllers/global-controller.dart';
import 'package:foodbank_marchantise_app/controllers/order_details_controller.dart';
import 'package:foodbank_marchantise_app/models/status_order_id.dart';
import 'package:foodbank_marchantise_app/utils/font_size.dart';
import 'package:foodbank_marchantise_app/utils/images.dart';
import 'package:foodbank_marchantise_app/utils/size_config.dart';
import 'package:foodbank_marchantise_app/utils/theme_colors.dart';
import 'package:foodbank_marchantise_app/widgets/order_detils_bottom_bar.dart';
import 'package:foodbank_marchantise_app/widgets/shimmer/oder_details_shimmer.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class Order_details extends StatefulWidget {
  int? orderId;
  Order_details({Key? key, this.orderId}) : super(key: key);

  @override
  _Order_detailsState createState() => _Order_detailsState();
}

class _Order_detailsState extends State<Order_details> {
  int statusValue = 0;
  int statusActive = 1;
  var orderStatusID;

  @override
  void initState() {
    // TODO: implement initState
    final orderDetailsController =
        Get.put(OrderDetailsController(widget.orderId));
    final settingsController = Get.put(GlobalController());
    orderDetailsController.onInit();
    settingsController.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    var orderDetailsController =
        Get.put(OrderDetailsController(widget.orderId));
    final settingsController = Get.put(GlobalController());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      orderDetailsController.onInit();
      print("onMessage data: ${message.data}");
    });
    Future<Null> _onRefresh() {
      setState(() {
        orderDetailsController.onInit();
      });
      Completer<Null> completer = new Completer<Null>();
      Timer timer = new Timer(new Duration(seconds: 3), () {
        completer.complete();
      });
      return completer.future;
    }

    return GetBuilder<OrderDetailsController>(
        init: OrderDetailsController(widget.orderId),
        builder: (orderDetails) => orderDetails.loader
            ? Order_detailsShimmer()
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Order Details",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: ThemeColors.baseThemeColor,
                  centerTitle: true,
                  elevation: 0.0,
                ),
                bottomNavigationBar: Order_details_bottom_bar(
                  subTotal:
                      orderDetails.orderDetailsByIdData!.subTotal.toString(),
                  deliveryFee: orderDetails.orderDetailsByIdData!.deliveryCharge
                      .toString(),
                  total: orderDetails.orderDetailsByIdData!.total,
                  orderID: orderDetails.orderDetailsByIdData!.id,
                  statusCode: orderDetails.statusCode,
                ),
                body: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      statusActive = 1;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: statusActive == 1
                                        ? BoxDecoration(
                                            color: ThemeColors.baseThemeColor,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          )
                                        : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            border: Border.fromBorderSide(
                                              BorderSide(
                                                color:
                                                    ThemeColors.baseThemeColor,
                                              ),
                                            ),
                                          ),
                                    child: Center(
                                        child: Text('Details',
                                            style: TextStyle(
                                                color: statusActive == 1
                                                    ? Colors.white
                                                    : ThemeColors
                                                        .baseThemeColor))),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      statusActive = 2;
                                    });
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 150,
                                    decoration: statusActive == 2
                                        ? BoxDecoration(
                                            color: ThemeColors.baseThemeColor,
                                            borderRadius:
                                                BorderRadius.circular(40))
                                        : BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            border: Border.fromBorderSide(
                                              BorderSide(
                                                color:
                                                    ThemeColors.baseThemeColor,
                                              ),
                                            ),
                                          ),
                                    child: Center(
                                      child: Text(
                                        'Tracking Order',
                                        style: TextStyle(
                                          color: statusActive == 2
                                              ? Colors.white
                                              : ThemeColors.baseThemeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          statusActive == 1
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  children: [
                                      //order id container
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 10, left: 15),
                                            child: orderDetails
                                                        .orderDetailsByIdData!
                                                        .deliveryBoy!
                                                        .id ==
                                                    null
                                                ? Container()
                                                : Row(
                                                    children: [
                                                      Icon(Icons.person_pin),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Delivery boy details",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ThemeColors
                                                                .scaffoldBgColor),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          orderDetails.orderDetailsByIdData!
                                                      .deliveryBoy!.id ==
                                                  null
                                              ? Container()
                                              : Container(
                                                  width: SizeConfig.screenWidth,
                                                  child: Card(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 5,
                                                          right: 5),
                                                      child: Row(
                                                        children: [
                                                          //shop image container
                                                          CachedNetworkImage(
                                                            imageUrl: orderDetails
                                                                .orderDetailsByIdData!
                                                                .deliveryBoy!
                                                                .image
                                                                .toString(),
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                                    width: SizeConfig
                                                                            .screenWidth! /
                                                                        4,
                                                                    height:
                                                                        SizeConfig.screenWidth! /
                                                                            4,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              10.0),
                                                                          bottomLeft:
                                                                              Radius.circular(10.0)),
                                                                    ),
                                                                    child: Image(
                                                                        image:
                                                                            imageProvider)),
                                                            placeholder: (context,
                                                                    url) =>
                                                                Shimmer
                                                                    .fromColors(
                                                              baseColor: Colors
                                                                  .grey[300]!,
                                                              highlightColor:
                                                                  Colors.grey[
                                                                      400]!,
                                                              child: Container(
                                                                  width: SizeConfig
                                                                          .screenWidth! /
                                                                      4,
                                                                  height: SizeConfig
                                                                          .screenWidth! /
                                                                      4,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                10.0),
                                                                        bottomLeft:
                                                                            Radius.circular(10.0)),
                                                                  ),
                                                                  child: Image(
                                                                      image: AssetImage(
                                                                          Images
                                                                              .shimmerImage))),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),

                                                          //shop descrption container

                                                          orderDetails
                                                                      .orderDetailsByIdData!
                                                                      .deliveryBoy!
                                                                      .id ==
                                                                  null
                                                              ? Container()
                                                              : Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        orderDetails
                                                                            .orderDetailsByIdData!
                                                                            .deliveryBoy!
                                                                            .name
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16,
                                                                            color:
                                                                                ThemeColors.scaffoldBgColor),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            5,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              orderDetails.orderDetailsByIdData!.deliveryBoy!.email.toString(),
                                                                              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14, color: ThemeColors.greyTextColor),
                                                                            ),
                                                                          ),
                                                                          Icon(Icons
                                                                              .email)
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            2,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            orderDetails.orderDetailsByIdData!.deliveryBoy!.phone.toString(),
                                                                            style: TextStyle(
                                                                                //color: Colors.white
                                                                                ),
                                                                          ),
                                                                          InkWell(
                                                                              onTap: (() {
                                                                                _makePhoneCall(orderDetails.orderDetailsByIdData!.deliveryBoy!.phone.toString());
                                                                              }),
                                                                              child: Icon(Icons.phone_enabled)),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),

                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 20, bottom: 10, left: 15),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Ordered Foods",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: ThemeColors
                                                      .scaffoldBgColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: orderDetails
                                            .orderDetailsByIdData!
                                            .items!
                                            .length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //SizedBox(height: 20,),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    bottom: 2),
                                              ),
                                              Card(
                                                elevation: 1,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2),
                                                  child: ListTile(
                                                    leading: CachedNetworkImage(
                                                      imageUrl: orderDetails
                                                          .orderDetailsByIdData!
                                                          .items![index]
                                                          .menuItem!
                                                          .image!,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: SizeConfig
                                                                .screenWidth! /
                                                            5,
                                                        width: SizeConfig
                                                                .screenWidth! /
                                                            5,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                      placeholder: (context,
                                                              url) =>
                                                          Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[400]!,
                                                        child: Container(
                                                            width: SizeConfig
                                                                    .screenWidth! /
                                                                4,
                                                            height: SizeConfig
                                                                    .screenWidth! /
                                                                4,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10.0),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10.0)),
                                                            ),
                                                            child: Image(
                                                                image: AssetImage(
                                                                    Images
                                                                        .shimmerImage))),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    ),
                                                    title: Text(
                                                      orderDetails
                                                          .orderDetailsByIdData!
                                                          .items![index]
                                                          .menuItem!
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            FontSize.xMedium,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    subtitle: Text(
                                                      Get.find<GlobalController>()
                                                              .currency! +
                                                          orderDetails
                                                              .orderDetailsByIdData!
                                                              .items![index]
                                                              .unitPrice
                                                              .toString() +
                                                          ' X ' +
                                                          orderDetails
                                                              .orderDetailsByIdData!
                                                              .items![index]
                                                              .quantity
                                                              .toString() +
                                                          ' = ' +
                                                          Get.find<
                                                                  GlobalController>()
                                                              .currency! +
                                                          orderDetails
                                                              .orderDetailsByIdData!
                                                              .items![index]
                                                              .itemTotal
                                                              .toString(),
                                                      style: TextStyle(
                                                        overflow:
                                                            TextOverflow.fade,
                                                        fontSize:
                                                            FontSize.medium,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            Get.find<GlobalController>()
                                                                    .currency! +
                                                                orderDetails
                                                                    .orderDetailsByIdData!
                                                                    .items![
                                                                        index]
                                                                    .unitPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: FontSize
                                                                  .medium,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            orderDetails
                                                                .orderDetailsByIdData!
                                                                .timeFormat
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize:
                                                                    FontSize
                                                                        .medium,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      //support phone
                                      settingsController.supportPhone == null
                                          ? Container()
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      top: 20,
                                                      bottom: 10,
                                                      left: 15),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                          FontAwesomeIcons
                                                              .phoneVolume,
                                                          color: ThemeColors
                                                              .baseThemeColor),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Support Number",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                            color: ThemeColors
                                                                .scaffoldBgColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: SizeConfig.screenWidth,
                                                  child: Card(
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 5,
                                                          right: 5),
                                                      child: Row(
                                                        children: [
                                                          //shop image container
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .headset,
                                                            color: ThemeColors
                                                                .baseThemeColor,
                                                            size: 40,
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                          ),

                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Call your support',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16,
                                                                      color: ThemeColors
                                                                          .scaffoldBgColor),
                                                                ),
                                                                SizedBox(
                                                                  height: 2,
                                                                ),
                                                                Text(
                                                                  '${settingsController.supportPhone.toString()}',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          14,
                                                                      color: ThemeColors
                                                                          .greyTextColor),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              _makePhoneCall(
                                                                  settingsController
                                                                      .supportPhone
                                                                      .toString());
                                                            },
                                                            icon: Icon(
                                                              Icons
                                                                  .phone_enabled,
                                                              color: ThemeColors
                                                                  .baseThemeColor,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ])
                              : Container(),

                          //order id container
                          statusActive == 2
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  children: [
                                      orderDetails.orderStatusArray.length != 1
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: 20,
                                                  bottom: 10,
                                                  left: 15),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Update status",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: ThemeColors
                                                            .scaffoldBgColor),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      //changing Status
                                      orderDetails.orderStatusArray.length != 1
                                          ? Container(
                                              height: 55,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .9,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(3)),
                                                color: Color(0xFFF2F2F2),
                                              ),
                                              child: ButtonTheme(
                                                alignedDropdown: true,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<
                                                      OrderStatusArray>(
                                                    value: orderDetails
                                                        .orderStatusArray[0],
                                                    isExpanded: true,
                                                    icon: Icon(Icons
                                                        .keyboard_arrow_down),
                                                    iconEnabledColor:
                                                        ThemeColors
                                                            .baseThemeColor,
                                                    items: orderDetails
                                                        .orderStatusArray
                                                        .map((OrderStatusArray
                                                            value) {
                                                      return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(
                                                          value.name.toString(),
                                                          style: TextStyle(
                                                            color: ThemeColors
                                                                .baseThemeColor,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        orderStatusID =
                                                            newValue;
                                                        print(newValue!.name);
                                                        if (newValue.id != 0) {
                                                          showAlertCompletDialog(
                                                              context,
                                                              newValue,
                                                              widget.orderId,
                                                              orderDetails);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(),

                                      Container(
                                        child: Theme(
                                          data: ThemeData(
                                            colorScheme:
                                                ColorScheme.fromSwatch()
                                                    .copyWith(
                                              primary:
                                                  ThemeColors.baseThemeColor,
                                            ),
                                          ),
                                          child: Stepper(
                                            physics: ClampingScrollPhysics(),
                                            controlsBuilder: (BuildContext
                                                    context,
                                                {VoidCallback? onStepContinue,
                                                VoidCallback? onStepCancel}) {
                                              return SizedBox(height: 0.0);
                                            },
                                            steps: getTrackingSteps(
                                                context,
                                                orderDetails.statusName,
                                                orderDetails.statusCode
                                                    .toString()),
                                            currentStep: statusValue,
                                          ),
                                        ),
                                      ),
                                    ])
                              : Container(),
                        ]),
                  ),
                ),
              ));
  }

  List<Step> getTrackingSteps(BuildContext context, statusName, status) {
    List<Step> _orderStatusSteps = [];
    if (status == '10') {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          'Order Cancel',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '',
            )),
        isActive: int.tryParse(status)! >= int.tryParse('10')!,
      ));
    } else {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          'Order Pending',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SizedBox(
          width: double.infinity,
          child: Text(
            '',
            style: TextStyle(
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        isActive: int.tryParse(status)! >= int.tryParse('5')!,
      ));
    }
    if (status == '12') {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          'Order Reject',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '',
            )),
        isActive: int.tryParse(status)! >= int.tryParse('12')!,
      ));
    } else {
      _orderStatusSteps.add(Step(
        state: StepState.complete,
        title: Text(
          'Order Accept',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        content: SizedBox(
            width: double.infinity,
            child: Text(
              '',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
        isActive: int.tryParse(status)! >= int.tryParse('14')!,
      ));
    }
    _orderStatusSteps.add(Step(
      state: StepState.complete,
      title: Text(
        'Order Process ',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: SizedBox(
          width: double.infinity,
          child: Text(
            '',
            style: TextStyle(
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          )),
      isActive: int.tryParse(status)! >= int.tryParse('15')!,
    ));
    _orderStatusSteps.add(Step(
      state: StepState.complete,
      title: Text(
        'On The Way',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: SizedBox(
          width: double.infinity,
          child: Text(
            '',
            style: TextStyle(
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          )),
      isActive: int.tryParse(status)! >= int.tryParse('17')!,
    ));
    _orderStatusSteps.add(Step(
      state: StepState.complete,
      title: Text(
        'Order Completed',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      content: SizedBox(
          width: double.infinity,
          child: Text(
            '',
            style: TextStyle(
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
          )),
      isActive: int.tryParse(status)! >= int.tryParse('20')!,
    ));
    return _orderStatusSteps;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  showAlertCompletDialog(
      BuildContext context, status, orderID, orderDetailsController) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        int? oId = int.parse(orderID);
        orderDetailsController.orderStatus(status.id.toString(), oId);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(status.name.toString()),
      content:
          Text("Are you sure you have ${status.name.toString()} the order?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
