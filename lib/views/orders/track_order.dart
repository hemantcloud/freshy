// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/myorders_model.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:freshy/views/utilities/datetime.dart';

import 'package:freshy/views/utilities/urls.dart';

class TrackOrder extends StatefulWidget {
  List<Items>? itemsModel;
  Orders orderModel;
  TrackOrder({Key? key,required this.itemsModel,required this.orderModel}) : super(key: key);

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.white,
          // Status bar brightness (optional)
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
            // color: Colors.black,
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
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    child: SvgPicture.asset('assets/icons/back.svg'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Track Order',
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
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Image.network(
                      Urls.imageUrl + widget.orderModel.vendorImage.toString(),
                      width: 50.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel.orderId == null ? '' : 'Order #${widget.orderModel.orderId} ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          widget.orderModel.vendorName.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          // 'Placed on Octobar 19 2021',
                          widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay == 'Pending' ? 'Placed on ${widget.orderModel.orderPlaced}' : widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending' ? 'Placed on ${widget.orderModel.orderPlaced}' : 'Placed on ${widget.orderModel.orderPlaced}',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                        Row(
                          children: [
                            Text(
                              'Items: ',
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              widget.itemsModel!.length.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Items: \$${widget.orderModel.total}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10.0),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/box_active.svg',
                        ),
                        DottedLine(
                          direction: Axis.vertical,
                          lineLength: 50.0,
                          lineThickness: 1.0,
                          dashGapLength: 1.0,
                          dashColor:
                          widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending'
                              ? AppColors.primaryColor
                              : widget.orderModel.status == 'Completed'
                                ? AppColors.primaryColor
                                : AppColors.secondaryColor,
                        ),
                        SvgPicture.asset(
                          widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending'
                              ? 'assets/icons/truck_active.svg'
                              : widget.orderModel.status == 'Completed'
                                ? 'assets/icons/truck_active.svg'
                                : 'assets/icons/truck.svg',
                        ),
                        DottedLine(
                          direction: Axis.vertical,
                          lineLength: 50.0,
                          lineThickness: 1.0,
                          dashGapLength: 1.0,
                          dashColor:
                          widget.orderModel.status == 'Completed'
                              ? AppColors.primaryColor
                              : AppColors.secondaryColor,
                        ),
                        SvgPicture.asset(
                          widget.orderModel.status == 'Completed'
                              ? 'assets/icons/delivered_active.svg'
                              : 'assets/icons/delivered_deactive.svg',
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        'Order Placed',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        widget.orderModel.orderPlaced.toString(),
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        width: MediaQuery.of(context).size.width * 0.61,
                        child: SvgPicture.asset(
                          'assets/images/solid_horizontal_line.svg',
                        ),
                      ),
                      Text(
                        'On The Way',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending'
                            ? '${Utility().DatefomatToMonth(widget.orderModel.oneTheWay.toString())} ${Utility().DatefomatToDate(widget.orderModel.oneTheWay.toString())} ${Utility().DatefomatToYear(widget.orderModel.oneTheWay.toString())}'
                            : widget.orderModel.status == 'Completed'
                              ? '${Utility().DatefomatToMonth(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToDate(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToYear(widget.orderModel.orderDelivered.toString())}'
                              : 'Pending',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 35.0),
                        width: MediaQuery.of(context).size.width * 0.61,
                        child: SvgPicture.asset(
                          'assets/images/solid_horizontal_line.svg',
                        ),
                      ),
                      Text(
                        'Order Delivered',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        widget.orderModel.status == 'Completed'
                            ? '${Utility().DatefomatToMonth(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToDate(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToYear(widget.orderModel.orderDelivered.toString())}'
                            : 'Pending',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
