// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/categories_model.dart';
import 'package:freshy/models/home_model.dart';
import 'package:freshy/models/search_model.dart';
import 'package:freshy/views/home/featured_vendors.dart';
import 'package:freshy/views/product/vendor_list.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:freshy/models/search_model.dart';
// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/urls.dart';
import 'package:freshy/views/utilities/toast.dart';
// apis

class SearchVendors extends StatefulWidget {
  const SearchVendors({Key? key}) : super(key: key);

  @override
  State<SearchVendors> createState() => _SearchVendorsState();
}

class _SearchVendorsState extends State<SearchVendors> {
  late SharedPreferences prefs;
  late String auth_token;
  List<Result>? featurevendorlist = [];
  var searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allProcess();
  }

  Future<void> allProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth_token = prefs.getString('auth_token')!;
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
        toolbarHeight: 150.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 40.0, bottom: 10.0),
          child: Column(
            children: [
              Container(
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
                      onTap: () => Navigator.of(context).pop(),
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
                          'Search Vendors',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60.0,
                margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: AppColors.secondaryDarkColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        width: 23.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        autofocus: true,
                        controller: searchController,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (String value){
                          searchapi(context, value);
                        },
                        cursorColor: AppColors.secondaryColor,
                        decoration: InputDecoration(
                          hintText: 'Search Keywords...',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            featurevendorlist!.isEmpty
                ? Center(
                    child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.center,
                    child: Text(
                      'No data yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ),
                  ))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2 / 2,
                      childAspectRatio: 8 / 12,
                    ),
                    itemCount: featurevendorlist!.length < 0
                        ? 1
                        : featurevendorlist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return featurevendorlist!.length < 0
                          ? Center(
                              child: Text(
                              'Not featured vendor added yet !',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ))
                          : Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                right: 5.0,
                                left: 5.0,
                              ),
                              child: Container(
                                height: 256.0,
                                padding:
                                    EdgeInsets.only(top: 20.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0.0),
                                  color: AppColors.featuredBgColor1,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      Urls.imageUrl +
                                          featurevendorlist![index]
                                              .image
                                              .toString(),
                                      height: 91.6,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/star.svg',
                                          height: 10.0,
                                          width: 10.0,
                                          color: AppColors.activeDotsColor,
                                        ),
                                        Text(
                                          featurevendorlist![index]
                                              .rating
                                              .toString(),
                                          style: TextStyle(
                                            color: AppColors.activeDotsColor,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      featurevendorlist![index].name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFEBEBEB),
                                      // color: Colors.black,
                                    ),
                                    Text(
                                      'View',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.secondaryColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // home api
  Future<void> searchapi(BuildContext context, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['page'] = 1;
    request['action'] = "vendor";
    request['keyword'] = value;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.searchUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    SearchModel res = await SearchModel.fromJson(jsonResponse);
    if (res.status == true) {
      featurevendorlist = res.data!.result;
      setState(() {});
    } else {
      Future.delayed(Duration.zero, () {
        if (res.message == 'The keyword field is required.') {
          featurevendorlist!.clear();
        }
      });
      setState(() {});
    }
    return;
  }
// home api
}
