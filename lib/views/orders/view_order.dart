// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/views/utilities/app_colors.dart';

import 'package:freshy/models/myorders_model.dart';
import 'package:freshy/views/utilities/datetime.dart';
import 'package:intl/intl.dart';

class ViewOrder extends StatefulWidget {
  List<Items>? itemsModel;
  Orders orderModel;
  ViewOrder({Key? key,required this.itemsModel,required this.orderModel}) : super(key: key);

  @override
  State<ViewOrder> createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'ORDER #${widget.orderModel.orderId}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay == 'Pending' ? 'Order placed,' + ' ${widget.itemsModel!.length} Items ' + '\$${widget.orderModel.total}' : widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending' ? 'On the way,' + ' ${widget.itemsModel!.length} Items ' + '\$${widget.orderModel.total}' : 'Delivered,' + ' ${widget.itemsModel!.length} Items ' + '\$${widget.orderModel.total}',
                          style: TextStyle(color: AppColors.secondaryColor,fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'HELP',
                  style: TextStyle(
                    color: AppColors.activeDotsColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0,
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
                    child: SvgPicture.asset(
                      'assets/images/ordered_locations.svg',
                      width: 20.0,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel.address!.from!.type.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          widget.orderModel.address!.from!.location.toString(),
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          widget.orderModel.address!.to!.type.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          widget.orderModel.address!.to!.location.toString(),
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEBEBEB),
              // color: Colors.black,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/right.svg',
                    color:
                    widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay == 'Pending'
                        ? Colors.transparent
                        : widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending'
                        ? Colors.transparent
                        : AppColors.primaryColor,
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Text(
                      widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay == 'Pending'
                          ? 'Order placed on ${widget.orderModel.orderPlaced}'
                          : widget.orderModel.status == 'Order placed' && widget.orderModel.oneTheWay != 'Pending'
                            ? 'On the way (Placed on ${widget.orderModel.orderPlaced})'
                            : 'Order Delivered on ${Utility().DatefomatToMonth(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToDate(widget.orderModel.orderDelivered.toString())} ${Utility().DatefomatToYear(widget.orderModel.orderDelivered.toString())}, ${Utility().DatefomatToTime24(widget.orderModel.orderDelivered.toString())}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Bill Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.itemsModel!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${widget.itemsModel![index].productName.toString()} X ${widget.itemsModel![index].qty.toString()}',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          Text(
                            '\$ ${widget.itemsModel![index].total.toString()}',
                            style: TextStyle(
                              color: Color(0xFF40404C),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Subtotal',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ),
                      Text(
                        '\$${widget.orderModel.subtotal}',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Shipping charges',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ),
                      Text(
                        '\$${widget.orderModel.shippingCharges}',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'VAT(${widget.orderModel.percentageVat}%)',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ),
                      Text(
                        '\$${widget.orderModel.vat}',
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Total',
                          style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '\$${widget.orderModel.total}',
                        style: TextStyle(color: Colors.black,fontSize: 20.0,fontWeight: FontWeight.w700),
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
