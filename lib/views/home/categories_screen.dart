// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/categories_model.dart';
import 'package:freshy/views/product/vendor_list.dart';
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

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late SharedPreferences prefs;
  late String auth_token;
  List<Items>? categorieslist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }

  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    categoriesapi(context);
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------{$auth_token}');
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
                      'Categories',
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
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            categorieslist!.isEmpty
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                        child: Text(
                      'No categories added yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    )))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 2 / 2,
                      childAspectRatio: 8 / 12,
                    ),
                    itemCount:
                        categorieslist!.length < 0 ? 1 : categorieslist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return categorieslist!.length < 0
                          ? Center(
                              child: Text(
                              'Not categories added yet !',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ))
                          : Padding(
                              padding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                right: 5.0,
                                left: 5.0,
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
                                      child: VendorList(category_id: categorieslist![index].id!,category_name: categorieslist![index].name.toString()),
                                    ),
                                  );
                                },
                                child: Container(
                                  // height: 250.0,
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  padding: EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          categorieslist![index]
                                              .name
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: AppColors.secondaryColor,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
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
  Future<void> categoriesapi(BuildContext context) async {
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
  }
// categories api
}
