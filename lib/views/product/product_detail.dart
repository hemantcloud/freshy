// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/product_detail_model.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:readmore/readmore.dart';

// apis
import 'dart:convert' as convert;
import 'dart:async';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/urls.dart';
import 'package:freshy/views/utilities/toast.dart';
// apis
class ProductDetail extends StatefulWidget {
  int productId;
  ProductDetail({Key? key,required this.productId}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late String auth_token;
  Product? productDetail;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allProcess();
  }

  Future<void> allProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    productdetailapi(context);
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------{$auth_token}');
    setState(() {});
  }
  List<String> category_namelist = [];
  variants(Product variant_list)async{
    category_namelist.clear();
    for(int i = 0; i < variant_list!.variant!.length; i++) {
      if (variant_list != "") {
        category_namelist.add(variant_list!.variant![i].perWeight!);
      }
    }
    print('category_namelist is -------------$category_namelist');
  }
  @override
  Widget build(BuildContext context) {
    if(productDetail != null){
      variants(productDetail!);
    }
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
          padding: EdgeInsets.only(top: 40.0,bottom: 10.0),
          child: Container(
            height: 60.0,
            // color: Colors.black,
            margin: EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent,width: 0.0),
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
                    child: SvgPicture.asset(
                        'assets/icons/back.svg'
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
        padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            productDetail == null ? Container() :
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.white,
              child:
              productDetail == null ?
              Image.asset(
                'assets/images/dummy_images.png',
              ) : Image.network(
                Urls.imageUrl + productDetail!.image.toString(),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productDetail == null
                        ? ''
                        : productDetail!.variantType != 'Yes'
                          ? productDetail!.price.toString() // if variantType is no
                          : productDetail == null
                            ? ''
                            : '\$ ${productDetail!.variant!.first.price.toString()}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.activeDotsColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    productDetail == null ? '' : productDetail!.title.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    productDetail == null ? '' : category_namelist.toString().replaceAll("[", "").replaceAll("]", ""),
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ReadMoreText(
                    productDetail == null ? '' : productDetail!.description.toString(),
                    trimLines: 5,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' More',
                    trimExpandedText: ' Less',
                    moreStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    lessStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          height: 60.0,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  child: Dashboard(bottomIndex: 2),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'Add to cart',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Container(
                  width: 20.0,
                  height: 20.0,
                  child: SvgPicture.asset(
                    'assets/icons/add_to_cart.svg',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),*/
    );
  }
  // vendors api
  Future<void> productdetailapi(BuildContext context) async {
    Loader.showAlertDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['product_id'] = widget.productId;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.productDetailUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.showAlertDialog(context, false);
    ProductDetailModel res = await ProductDetailModel.fromJson(jsonResponse);
    if (res.status == true) {
      productDetail = res.data!.product;
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }
// vendors api
}