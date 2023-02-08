// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/myorders_model.dart';
import 'package:freshy/views/orders/rate_order.dart';
import 'package:freshy/views/orders/view_order.dart';
import 'package:freshy/views/orders/track_order.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/urls.dart';
import 'package:freshy/views/utilities/toast.dart';
// apis

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key}) : super(key: key);

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  late String auth_token;
  List<Orders>? myorderslist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      this.allProcess();
    });
  }

  Future<void> allProcess() async {
    myordersapi(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        toolbarHeight: 80.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
          child: Container(
            height: 60.0,
            margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 0.0),
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'My Orders',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            myorderslist!.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.center,
                    child: Text(
                      'No orders yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        myorderslist!.length < 0 ? 0 : myorderslist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MyOrdersList(
                        index: index,
                        myorderslist: myorderslist![index],
                      );
                    },
                  ),
            /*Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delivered',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  SvgPicture.asset(
                    'assets/icons/delivered.svg',
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // my orders api
  Future<void> myordersapi(BuildContext context) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.myOrderUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    MyOrdersModel res = await MyOrdersModel.fromJson(jsonResponse);
    if (res.status == true) {
      myorderslist = res.data!.orders;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }

  // my orders api
}

class MyOrdersList extends StatefulWidget {
  int index;
  Orders myorderslist;
  MyOrdersList({required this.index, required this.myorderslist});

  @override
  State<MyOrdersList> createState() => _MyOrdersListState();
}

class _MyOrdersListState extends State<MyOrdersList> {
  List<String> itemslist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      itemlistfunction(widget.myorderslist);
    });
  }

  itemlistfunction(Orders myorderslist) async {
    itemslist.clear();
    for (int i = 0; i < myorderslist.items!.length; i++) {
      itemslist.add(
          '${myorderslist.items![i].perWeight!} X ${myorderslist.items![i].qty!}');
      setState(() {});
    }
    // print('itemslist is ---------------$itemslist');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  widget.myorderslist.vendorName.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Text(
                widget.myorderslist.status == 'Order placed' &&
                        widget.myorderslist.oneTheWay == 'Pending'
                    ? 'Order placed'
                    : widget.myorderslist.status == 'Order placed' &&
                            widget.myorderslist.oneTheWay != 'Pending'
                        ? 'On the way'
                        : 'Delivered',
                style: TextStyle(
                  color: AppColors.orangeColor,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$ ${widget.myorderslist.total.toString()}',
                style: TextStyle(
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              /*Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType
                            .rightToLeftWithFade,
                        alignment:
                        Alignment.topCenter,
                        duration: Duration(
                            milliseconds: 500),
                        isIos: true,
                        child: RateOrder(orderId: widget.myorderslist.orderId.toString()),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.myorderslist.isRated == 'Yes' ? 'Already Rated' : 'Rate Order',
                      style: TextStyle(
                        color: widget.myorderslist.isRated == 'Yes' ? AppColors.primaryColor  : AppColors.redColor,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
          SvgPicture.asset(
            'assets/images/dotted_line.svg',
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              itemslist.toString().replaceAll("[", "").replaceAll("]", ""),
              style: TextStyle(
                color: AppColors.secondaryColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        alignment: Alignment.topCenter,
                        duration: Duration(milliseconds: 500),
                        isIos: true,
                        child: ViewOrder(
                            itemsModel: widget.myorderslist.items,
                            orderModel: widget.myorderslist),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 42.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text(
                      'View',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: widget.myorderslist.status != 'Completed'
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              alignment: Alignment.topCenter,
                              duration: Duration(milliseconds: 500),
                              isIos: true,
                              child: TrackOrder(
                                  itemsModel: widget.myorderslist.items,
                                  orderModel: widget.myorderslist),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 42.0,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: Text(
                            'Track Order',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      )
                    : widget.myorderslist.isRated == 'Yes'
                        ? Container(
                            alignment: Alignment.center,
                            height: 42.0,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Text(
                              'Rated',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 13.0,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.rightToLeftWithFade,
                                  alignment: Alignment.topCenter,
                                  duration: Duration(milliseconds: 500),
                                  isIos: true,
                                  child: RateOrder(
                                      orderId: widget.myorderslist.orderId
                                          .toString()),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 42.0,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              child: Text(
                                'Rate Now',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
