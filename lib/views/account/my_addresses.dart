// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/delete_address_model.dart';
import 'package:freshy/models/get_address_model.dart';
import 'package:freshy/models/update_address_model.dart';
import 'package:freshy/views/utilities/app_colors.dart';
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

class MyAddresses extends StatefulWidget {
  const MyAddresses({Key? key}) : super(key: key);

  @override
  State<MyAddresses> createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> {
  bool isHomeSelected = false;
  bool isWorkSelected = false;
  bool isOtherSelected = false;
  late String auth_token;
  loc.LocationData? locationData;
  List<Address>? addresslist = [];
  String updateselectedaddresstype = '';
  String addselectedaddresstype = '';
  var addHouseController = TextEditingController();
  var addApartmentController = TextEditingController();
  var updateHouseController = TextEditingController();
  var updateApartmentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }

  Future<void> all_process() async {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getaddressapi(context);
    getPermission();
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------$auth_token');
    print('addresslist length is ----------------$addresslist');
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
                InkWell(
                  onTap: () => Navigator.pop(context),
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
                      'Manage Address',
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
        padding: EdgeInsets.fromLTRB(20.0,20.0,20.0,100.0),
        child: Column(
          children: [
            addresslist!.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/location.svg',
                            width: MediaQuery.of(context).size.width * 0.1),
                        SizedBox(height: 8.0),
                        Text(
                          'No Addresses Added Yet?',
                          style: TextStyle(color: AppColors.secondaryColor),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Saved Addresses',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addresslist!.length < 0 ? 1 : addresslist!.length,
              itemBuilder: (BuildContext context, int index) {
                return addresslist!.length < 0
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  addresslist![index].type == 'Home'
                                      ? 'assets/icons/home_save_address_unselected.svg'
                                      : addresslist![index].type == 'Work'
                                          ? 'assets/icons/bag2.svg'
                                          : 'assets/icons/location.svg',
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      addresslist![index].type == 'Home' ?
                                      'Home' : addresslist![index].type == 'Work' ? 'Work' : 'Other',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: Text(
                                        '${addresslist![index].house}, ${addresslist![index].apartment}',
                                        style: TextStyle(
                                          color: AppColors.secondaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            updateHouseController.text = addresslist![index].house.toString();
                                            updateApartmentController.text = addresslist![index].apartment.toString();
                                            setState(() {});
                                            editAddress(
                                                context,
                                                addresslist![index].id.toString(),
                                                updateHouseController.text,
                                                updateApartmentController.text,
                                                addresslist![index].type.toString(),
                                                addresslist![index].lat.toString(),
                                                addresslist![index].lng.toString()
                                            );
                                          },
                                          child: Text(
                                            'EDIT',
                                            style: TextStyle(
                                              color: AppColors.activeDotsColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        InkWell(
                                          onTap: () {
                                            confirmModel(context,addresslist![index].id.toString());
                                          },
                                          child: Text(
                                            'DELETE',
                                            style: TextStyle(
                                              color: AppColors.redColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
                        ],
                      );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            addAddress(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60.0,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Text(
              'Add new address',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            },
          );
        });
  }

  editAddress(BuildContext context,String id,String house,String apartment,String type,String lat,String lng) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          // yaha
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: 299.0,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        // textAlignVertical: TextAlignVertical.bottom,
                       controller: updateHouseController,
                        keyboardType: TextInputType.streetAddress,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        cursorColor: AppColors.secondaryColor,
                        //initialValue: house,
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
                        // textAlignVertical: TextAlignVertical.bottom,
                        controller: updateApartmentController,
                        keyboardType: TextInputType.streetAddress,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        cursorColor: AppColors.secondaryColor,
                        //initialValue: apartment,
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
                              updateselectedaddresstype = 'Home';
                              type = 'Home';
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                              margin: EdgeInsets.only(right: 5.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFDEDEDE)),
                                borderRadius:BorderRadius.all(Radius.circular(15.0)),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/home_save_address.svg',
                                    width: 18.0,
                                    height: 18.0,
                                    color: type == 'Home'
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Home',
                                    style: TextStyle(
                                      color: type == 'Home'
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
                              updateselectedaddresstype = 'Work';
                              type = 'Work';
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
                                    color: type == 'Work'
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Work',
                                    style: TextStyle(
                                      color: type == 'Work'
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
                              updateselectedaddresstype = 'Other';
                              type = 'Other';
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
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
                                    color: type == 'Other'
                                        ? AppColors.DarkBlueColor
                                        : AppColors.secondaryLightColor,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    'Other',
                                    style: TextStyle(
                                      color: type == 'Other'
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
                          var house = updateHouseController.text;
                          var apart = updateApartmentController.text;
                          if (house.isEmpty) {
                            UtilityToaster().getToast("Please Enter House address.");
                          } else if (apart.isEmpty) {
                            UtilityToaster().getToast("Please Enter Apratment address.");
                          } else {
                             updateaddressapi(context, id, type);
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
                              'Update address',
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
            },
          );
        });
  }

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
    GetAddressModel responsegetaddress = await GetAddressModel.fromJson(jsonResponse);
    if (responsegetaddress.status == true) {
      addresslist = responsegetaddress.data!.address;
      setState(() {});
    } else {
      UtilityToaster().getToast(responsegetaddress.message);
      setState(() {});
    }
    return;
  }
  // getaddressapi api
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
      Navigator.pop(context);
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
  // updateaddressapi api
  Future<void> updateaddressapi(BuildContext context,String id,String type) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['id'] = id;
    request['house'] = updateHouseController.text;
    request['apartment'] = updateApartmentController.text;
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
      UtilityToaster().getToast('Address updated successfully.');
      addresslist!.clear();
      getaddressapi(context);
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
  // updateaddressapi api
  // delete api
  Future<void> deleteaddressapi(BuildContext context,String id) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['id'] = id;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.deleteupadteAddressUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    DeleteAddressModel res = await DeleteAddressModel.fromJson(jsonResponse);
    if (res.status == true) {
      Navigator.pop(context);
      UtilityToaster().getToast(res.message);
      addresslist!.clear();
      getaddressapi(context);
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
  // delete api

  Future confirmModel(context,String id) {
    return showDialog(
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
                'Are you sure do you want to delete the address!',
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
                        deleteaddressapi(context, id);
                        Future.delayed(Duration(seconds: 1),(){
                          Navigator.pop(context);
                        });
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
