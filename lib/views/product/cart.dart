// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/addtocart_model.dart';
import 'package:freshy/models/delete_cart_model.dart';
import 'package:freshy/models/get_address_model.dart';
import 'package:freshy/models/get_cart_model.dart';
import 'package:freshy/models/placeorder_model.dart';
import 'package:freshy/models/update_address_model.dart';
import 'package:freshy/views/orders/order_success.dart';
import 'package:freshy/views/product/payment_method.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/urls.dart';
import 'package:freshy/views/utilities/toast.dart';
// apis

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late String auth_token;
  List<Items>? getcartitemslist = [];
  List<Address>? addresslist = [];
  CartTotal? cartDetails;
  int myItemCount = 1;
  bool? cartStatus;
  loc.LocationData? locationData;
  var addHouseController = TextEditingController();
  var addApartmentController = TextEditingController();
  String addselectedaddresstype = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      this.allProcess();
    });
  }

  Future<void> allProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getaddressapi(context);
    getcartapi(context, 0);
    getPermission();
    auth_token = prefs.getString('auth_token')!;
    setState(() {});
  }
  Future getPermission() async {
    if (await Permission.location.isGranted) {
      getLatLong();
    } else {
      Permission.location.request();
    }
  }
  Future getLatLong() async {
    locationData = await loc.Location.instance.getLocation();
    print('lat : ---------' + locationData!.latitude.toString());
    print('long : ---------' + locationData!.longitude.toString());
  }

  bool isHomeSelected = false;
  bool isWorkSelected = false;
  bool isOtherSelected = false;
  bool? isAddressAvailable;

  String currentAddress = "";
  String currentAddressType = "";
  int currentAddressId = 0;
  String paymentMethod = 'Wallet';
  GetData(String paymenttype){
    paymentMethod = paymenttype;
    setState(() {});
  }

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
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Shopping Cart',
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
        padding: EdgeInsets.only(bottom: 254.0),
        child: Column(
          children: [
            isAddressAvailable == true
                ? Container(
                    color: Color(0xFFF9FDF6),
                    height: 78.0,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          currentAddressType.isEmpty || currentAddressType == ''
                              ? addresslist!.first.type == 'Home'
                                  ? 'assets/icons/home_save_address_unselected.svg'
                                  : addresslist!.first.type == 'Work'
                                      ? 'assets/icons/bag2.svg'
                                      : 'assets/icons/location.svg'
                              : currentAddressType == "Home"
                                  ? 'assets/icons/home_save_address_unselected.svg'
                                  : currentAddressType == 'Work'
                                      ? 'assets/icons/bag2.svg'
                                      : 'assets/icons/location.svg',
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery at',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  currentAddress.isEmpty || currentAddress == ""
                                      ? '${addresslist!.first.house.toString()}, ${addresslist!.first.apartment.toString()}'
                                      : currentAddress,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            changeAddress(context);
                          },
                          child: Text(
                            'Change',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  getcartitemslist!.length < 0 ? 1 : getcartitemslist!.length,
              itemBuilder: (BuildContext context, int index) {
                return getcartitemslist!.length < 0
                    ? Text(
                        'Cart is Empty',
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(
                        width: MediaQuery.of(context).size.width * 1,
                        padding: const EdgeInsets.all(10.0),
                        margin:
                            const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$ ${getcartitemslist![index].price.toString()} × ${getcartitemslist![index].qty.toString()}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.activeDotsColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    int priceIncrease = int.parse(getcartitemslist![index].qty.toString());
                                    priceIncrease++;
                                    getcartitemslist![index].qty = priceIncrease.toString();
                                    addtocartapi2(context,getcartitemslist![index].productId.toString(),getcartitemslist![index].variantId.toString(),getcartitemslist![index].qty.toString());
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      getcartitemslist![index]
                                          .productTitle
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1,right: 5.0),
                                    child: Text(getcartitemslist![index].qty.toString(),),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getcartitemslist![index].perWeight.toString(),
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    int priceDecrease = int.parse(getcartitemslist![index].qty.toString());
                                    if (priceDecrease > 1) {
                                      priceDecrease--;
                                      getcartitemslist![index].qty = priceDecrease.toString();
                                      addtocartapi2(context,getcartitemslist![index].productId.toString(),getcartitemslist![index].variantId.toString(),getcartitemslist![index].qty.toString());
                                      myItemCount = int.parse(getcartitemslist![index].qty.toString());
                                    }else{
                                      confirmModel(context,getcartitemslist![index].id!);
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 20.0,
                                    height: 20.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 234.0,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtotal',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Shipping charges',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      cartDetails == null
                          ? 'VAT(0%)'
                          : 'VAT(${cartDetails!.vatPerc}%)',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cartDetails == null ? '\$0' : '\$${cartDetails!.subtotal}',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      cartDetails == null
                          ? '\$0'
                          : '\$${cartDetails!.shippingCharges}',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      cartDetails == null ? '\$0' : '\$${cartDetails!.vat}',
                      style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 1,
              thickness: 1,
              color: Color(0xFFEBEBEB),
              // color: Colors.black,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cartDetails == null ? '\$0' : '\$${cartDetails!.total}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            isAddressAvailable == true
                ? cartStatus == false
                    ? Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.boxShadowColor,
                              offset: Offset(0.0, 10.0),
                              blurRadius: 9.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Cart is Empty',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    alignment: Alignment.topCenter,
                                    duration: Duration(milliseconds: 1000),
                                    isIos: true,
                                    child: PaymentMethod(GetData: GetData,paymentMethod: paymentMethod),
                                  ),
                                );
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PAY USING',
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    paymentMethod.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.boxShadowColor,
                                    offset: Offset(0.0, 10.0),
                                    blurRadius: 9.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () {
                                  int? addressIdApi;
                                  if(currentAddressId == 0){
                                    addressIdApi = addresslist!.first.id;
                                  }else{
                                    addressIdApi = currentAddressId;
                                  }
                                  placeorderapi(context, addressIdApi!, paymentMethod);
                                },
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Place order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                : Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.boxShadowColor,
                          offset: Offset(0.0, 10.0),
                          blurRadius: 9.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        addAddress(context);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Add address to process',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  addAddress(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 299.0,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        controller: addHouseController,
                        keyboardType: TextInputType.streetAddress,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        cursorColor: AppColors.secondaryColor,
                        decoration: const InputDecoration(
                          hintText: 'House / Flat / Floor No.',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEBEBEB),
                        // color: Colors.black,
                      ),
                      TextFormField(
                        controller: addApartmentController,
                        keyboardType: TextInputType.streetAddress,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        cursorColor: AppColors.secondaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Apartment / Road / Area (Optional )',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEBEBEB),
                        // color: Colors.black,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Save As',
                          style: TextStyle(
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              addselectedaddresstype = 'Home';
                              isHomeSelected = !isHomeSelected;
                              if (isWorkSelected == true) {
                                isWorkSelected = false;
                              }
                              if (isOtherSelected == true) {
                                isOtherSelected = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDEDEDE)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/home_save_address.svg',
                                    width: 18.0,
                                    height: 18.0,
                                    color: isHomeSelected == true
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                      color: isHomeSelected == true
                                          ? AppColors.DarkBlueColor
                                          : AppColors.secondaryLightColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addselectedaddresstype = 'Work';
                              isWorkSelected = !isWorkSelected;
                              if (isHomeSelected == true) {
                                isHomeSelected = false;
                              }
                              if (isOtherSelected == true) {
                                isOtherSelected = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDEDEDE)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/bag_save_address.svg',
                                    width: 18.0,
                                    height: 18.0,
                                    color: isWorkSelected == true
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Work',
                                    style: TextStyle(
                                      color: isWorkSelected == true
                                          ? AppColors.DarkBlueColor
                                          : AppColors.secondaryLightColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              addselectedaddresstype = 'Other';
                              isOtherSelected = !isOtherSelected;
                              if (isHomeSelected == true) {
                                isHomeSelected = false;
                              }
                              if (isWorkSelected == true) {
                                isWorkSelected = false;
                              }
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDEDEDE)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/location_save_address.svg',
                                    width: 18.0,
                                    height: 18.0,
                                    color: isOtherSelected == true
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Other',
                                    style: TextStyle(
                                      color: isOtherSelected == true
                                          ? AppColors.DarkBlueColor
                                          : AppColors.secondaryLightColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          String house = addHouseController.text;
                          String apartment = addApartmentController.text;
                          if(house.isEmpty){
                            UtilityToaster().getToast("Please Enter House address.");
                          } else if(apartment.isEmpty){
                            UtilityToaster().getToast("Please Enter Apartment address.");
                          } else if(isHomeSelected == false && isWorkSelected == false && isOtherSelected == false){
                            UtilityToaster().getToast('Please select address type');
                          }else{
                            addaddressapi(context, addselectedaddresstype);
                            Future.delayed(Duration(seconds: 1),(){
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Container(
                          height: 60.0,
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.boxShadowColor,
                                offset: Offset(0.0, 10.0),
                                blurRadius: 9.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Save address details',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  changeAddress(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    padding: EdgeInsets.all(20.0),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 20.0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Choose a Delivery Address',
                            style: TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFEBEBEB),
                          // color: Colors.black,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              addresslist!.length < 0 ? 1 : addresslist!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return addresslist!.length < 0
                                ? Container()
                                : Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          currentAddress = addresslist![index].house.toString() +', ' +addresslist![index].apartment.toString();
                                          currentAddressType = addresslist![index].type.toString();
                                          currentAddressId = addresslist![index].id!;
                                          this.setState(() {});
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                addresslist![index].type ==
                                                        'Home'
                                                    ? 'assets/icons/home_save_address_unselected.svg'
                                                    : addresslist![index]
                                                                .type ==
                                                            'Work'
                                                        ? 'assets/icons/bag2.svg'
                                                        : 'assets/icons/location.svg',
                                              ),
                                              SizedBox(width: 10.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Delivery at',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15.0,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    child: Text(
                                                      '${addresslist![index].house.toString()}, ${addresslist![index].apartment.toString()}',
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .secondaryColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFFEBEBEB),
                                        // color: Colors.black,
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  // get cart api
  Future<void> getcartapi(BuildContext context, int addressId) async {
    if(getcartitemslist!.length <= 1){
      if(myItemCount < 1){
        getcartitemslist!.clear();
        cartDetails = null;
      }
    }
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['address_id'] = addressId;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.getCartUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    GetCartModel res = await GetCartModel.fromJson(jsonResponse);
    if (res.status == true) {
      getcartitemslist = res.data!.cart!.items;
      cartDetails = res.data!.cartTotal;
      cartStatus = res.status;
      setState(() {});
    } else {
      cartStatus = res.status;
      if (res.message != "cart is empty") {
        UtilityToaster().getToast(res.message);
      }
      setState(() {});
    }
    return;
  }

  // get cart api
  // getaddressapi api
  Future<void> getaddressapi(BuildContext context) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.getAddressUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    GetAddressModel res = await GetAddressModel.fromJson(jsonResponse);
    if (res.status == true) {
      addresslist = res.data!.address;
      if (addresslist!.isEmpty) {
        isAddressAvailable = false;
      } else {
        isAddressAvailable = true;
      }
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }

  // getaddressapi api
  // placeorder api
  Future<void> placeorderapi(BuildContext context,int addressIdApi,String paymentMethod) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['address_id'] = addressIdApi;
    request['payment_method'] = paymentMethod;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.placeOrderUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    PlaceOrderModel res = await PlaceOrderModel.fromJson(jsonResponse);
    if (res.status == true) {
      setState(() {});
      // Future.delayed(Duration.zero, () {
      //   this.allProcess();
      // });
      Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 1000),
          isIos: true,
          child: OrderSuccess(),
        ),
        (route) => false,
      );
      });
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }

  // placeorderapi api
  // add to cart api
  Future<void> addtocartapi2(BuildContext context, String productId,String variantId, String qty) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['product_id'] = productId;
    request['variant_id'] = variantId;
    request['qty'] = qty;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.addToCartUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    AddToCartModel res = await AddToCartModel.fromJson(jsonResponse);
    if (res.status == true) {
      getcartapi(context, 0);
      UtilityToaster().getToast(res.message);
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }

  // add to cart api
  // delete cart api
  Future<void> deletecartapi(BuildContext context, int cartId, int addressId) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['cart_id'] = cartId;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.deleteCartUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    DeleteCartModel res = await DeleteCartModel.fromJson(jsonResponse);
    if (res.status == true) {
      getcartapi(context, addressId);
      UtilityToaster().getToast(res.message);
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }

  // delete cart api
  // addaddressapi api
  Future<void> addaddressapi(BuildContext context,String type) async {
    Loader.hideKeyboard();
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['house'] = addHouseController.text;
    request['apartment'] = addApartmentController.text;
    request['type'] = type;
    request['lat'] = locationData!.latitude.toString();
    request['lng'] = locationData!.longitude.toString();
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.addupadteAddressUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    UpdateAddressModel res = await UpdateAddressModel.fromJson(jsonResponse);
    if (res.status == true) {
      UtilityToaster().getToast(res.message);
      addresslist!.clear();
      getaddressapi(context);
      addHouseController.text = '';
      addApartmentController.text = '';
      isHomeSelected = false;
      isWorkSelected = false;
      isOtherSelected = false;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
  // addaddressapi api
  Future confirmModel(context,int cartId) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0,),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: Colors.white),
            color: Colors.white,
          ),
          height: 350.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('?',style: TextStyle(color: AppColors.primaryColor,fontSize: 50.0),),
              const Text(
                'Are you sure to delete the product from cart!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.secondaryColor,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
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
                          'Cancel',
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
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        deletecartapi(context, cartId,currentAddressId);
                        myItemCount = 0;
                        // Future.delayed(Duration(seconds: 1),(){
                          Navigator.of(context).pop();
                        // });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 42.0,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text(
                          'Delete',
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
        ),
      ),
    );
  }
}
