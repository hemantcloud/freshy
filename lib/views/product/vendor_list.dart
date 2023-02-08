// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/vendors_model.dart';
import 'package:freshy/views/product/vendor_products.dart';
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

class VendorList extends StatefulWidget {
  int category_id;
  String category_name;
  VendorList({Key? key, required this.category_id, required this.category_name})
      : super(key: key);

  @override
  State<VendorList> createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  late String auth_token;
  List<Vendors>? vendorslist = [];
  List<Categories>? vendorscategorylist = [];
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
    vendorsapi(context);
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------{$auth_token}');
    setState(() {});
  }

  List<String> category_namelist = [];
  variantslist(Vendors category_image)async{
    category_namelist.clear();
    for(int i = 0; i < category_image.categories!.length; i++) {
      if (category_image != "") {
        category_namelist.add(category_image.categories![i].name!);
      }
    }
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
                      widget.category_name,
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
            vendorslist!.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                        child: Text(
                      'No vendors added yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    )))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        vendorslist!.length < 0 ? 1 : vendorslist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      variantslist(vendorslist![index]);
                      return vendorslist!.length < 0
                          ? Center(
                              child: Text(
                              'Not vendors added yet !',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ))
                          : Container(
                              height: 100.0,
                              width: MediaQuery.of(context).size.width * 1,
                              padding: const EdgeInsets.all(10.0),
                              margin: const EdgeInsets.only(bottom: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0.0),
                                color: Colors.white,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      alignment: Alignment.topCenter,
                                      duration: Duration(milliseconds: 1000),
                                      isIos: true,
                                      child: VendorsProducts(vendorId: vendorslist![index].id!,vendorName: vendorslist![index].name.toString()),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 20.0),
                                      child: Image.network(
                                        Urls.imageUrl +
                                            vendorslist![index]
                                                .image
                                                .toString(),
                                        height: 70.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            vendorslist![index].name.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/star.svg',
                                                height: 10.0,
                                                width: 10.0,
                                                color:
                                                    AppColors.activeDotsColor,
                                              ),
                                              Text(
                                                vendorslist![index]
                                                    .rating
                                                    .toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color:
                                                      AppColors.activeDotsColor,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.4,
                                            child: Text(
                                              category_namelist == null ? '' : category_namelist.toString().replaceAll("[", "").replaceAll("]", ""),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: AppColors.secondaryColor,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    vendorslist![index].isVerified == "0"
                                        ? Container()
                                        : Image.asset(
                                            'assets/images/verified.png',
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

  // vendors api
  Future<void> vendorsapi(BuildContext context) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['category_id'] = widget.category_id;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.vendorsUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    VendorsModel res = await VendorsModel.fromJson(jsonResponse);
    if (res.status == true) {
      vendorslist = res.data!.vendors;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
  // vendors api
}
