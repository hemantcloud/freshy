// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/home_model.dart';
import 'package:freshy/models/search_model.dart';
import 'package:freshy/test.dart';
import 'package:freshy/views/home/categories_screen.dart';
import 'package:freshy/views/home/featured_vendors.dart';
import 'package:freshy/views/home/home_slider.dart';
import 'package:freshy/views/home/search_vendors.dart';
import 'package:freshy/views/product/vendor_list.dart';
import 'package:freshy/views/product/vendor_products.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/urls.dart';
import 'package:freshy/views/utilities/toast.dart';
// apis

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final List<String> imgList = [
  //   'assets/images/slide1.png',
  //   'assets/images/slide2.webp',
  // ];
  late SharedPreferences prefs;
  late String auth_token;
  List<Category>? categorieslist = [];
  List<BannerModel>? imgList = [];
  List<FeatureVendor>? featurevendorlist = [];
  loc.LocationData? locationData;
  var searchController = TextEditingController();

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
    homeapi(context);
    getPermission();
    auth_token = prefs.getString('auth_token')!;
    print('auth_token is------------$auth_token');
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
      backgroundColor: Colors.white,
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
              color: AppColors.secondaryDarkColor,
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    alignment: Alignment.topCenter,
                    duration: Duration(milliseconds: 500),
                    isIos: true,
                    child: SearchVendors(),
                  ),
                );
              },
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
                    child: Text(
                      'Search keywords..',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            imgList!.isEmpty
                ? Container(
                    height: 283.0,
                    child: Center(
                      child: Text(
                        'No data yet !',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    ),
                  )
                : HomeSlider(imgList: imgList),
            InkWell(
              onTap: () => Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  alignment: Alignment.topCenter,
                  duration: Duration(milliseconds: 1000),
                  isIos: true,
                  child: CategoriesScreen(),
                ),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/forward.svg',
                      // width: 20.0,
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
              child: categorieslist!.isEmpty
                  ? Center(
                      child: Text(
                      'No categories added yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: categorieslist!.length < 0 ? 1 : 6,
                      itemBuilder: (context, index) {
                        return categorieslist!.length < 0
                            ? Center(
                                child: Text(
                                'No categories added yet !',
                                style:
                                    TextStyle(color: AppColors.secondaryColor),
                              ))
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          alignment: Alignment.topCenter,
                                          duration:
                                              Duration(milliseconds: 1000),
                                          isIos: true,
                                          child: VendorList(
                                              category_id:
                                                  categorieslist![index].id!,
                                              category_name:
                                                  categorieslist![index]
                                                      .name
                                                      .toString()),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 52.0,
                                          height: 52.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFE6F2EA),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100.0)),
                                          ),
                                          padding: EdgeInsets.all(10.0),
                                          child: Image.network(
                                            Urls.imageUrl +
                                                categorieslist![index]
                                                    .image
                                                    .toString(),
                                            width: 32.0,
                                          ),
                                        ),
                                        Text(
                                          categorieslist![index]
                                              .name
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: AppColors.secondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                ],
                              );
                      }),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    alignment: Alignment.topCenter,
                    duration: Duration(milliseconds: 1000),
                    isIos: true,
                    child: FeaturedVendors(),
                  ),
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Vendors',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/forward.svg',
                      // width: 20.0,
                      color: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
            featurevendorlist!.isEmpty
                ? Container()
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2 / 2,
                      childAspectRatio: 8 / 12,
                    ),
                    itemCount: featurevendorlist!.length < 0 ? 0 : 4,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              alignment: Alignment.topCenter,
                              duration: Duration(milliseconds: 1000),
                              isIos: true,
                              child: VendorsProducts(
                                  vendorId: featurevendorlist![index].id!,
                                  vendorName: featurevendorlist![index]
                                      .name
                                      .toString()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 10.0,
                            bottom: 10.0,
                            right: 5.0,
                            left: 5.0,
                          ),
                          child: Container(
                            height: 256.0,
                            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                              color: AppColors.featuredBgColor1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.network(
                                  Urls.imageUrl +
                                      featurevendorlist![index]
                                          .image
                                          .toString(),
                                  height: 91.6,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  // categories api
  /*Future<void> categoriesapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.categoriesUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    CategoriesModel res = await CategoriesModel.fromJson(jsonResponse);
    if (res.status == true) {
      categorieslist = res.data!.items;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }*/
  // categories api
  // home api
  Future<void> homeapi(BuildContext context) async {
    featurevendorlist!.clear();
    categorieslist!.clear();
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.homeapiUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    HomeModel res = await HomeModel.fromJson(jsonResponse);
    if (res.status == true) {
      categorieslist = res.data!.category;
      imgList = res.data!.banner;
      featurevendorlist = res.data!.featureVendor;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
  // home api
}
