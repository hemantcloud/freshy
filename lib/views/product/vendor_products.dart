// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/addtocart_model.dart';
import 'package:freshy/models/delete_cart_model.dart';
import 'package:freshy/models/get_cart_model.dart';
import 'package:freshy/models/vendors_product_model.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/product/product_detail.dart';
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

class VendorsProducts extends StatefulWidget {
  int vendorId;
  String vendorName;
  VendorsProducts({Key? key, required this.vendorId, required this.vendorName})
      : super(key: key);

  @override
  State<VendorsProducts> createState() => _VendorsProductsState();
}

class _VendorsProductsState extends State<VendorsProducts> {
  late String auth_token;
  List<Services>? serviceslist = [];
  List<Products>? productlist = [];
  List<Items>? getcartitemslist = [];
  bool? cartStatus;
  String? cartSubTotal;
  bool? showLoader;
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
    vendorsproductapi(context, 0,true);
    getcartapi(context, 0);
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------{$auth_token}');
    setState(() {});
  }

  onCallBack(int myVariantId, String Qty, String productPrice, String id) async {
    for (int i = 0; i < productlist!.length; i++) {
      if (productlist![i].id.toString() == id.toString()) {
        productlist![i].price = productPrice;
        productlist![i].itemCount = Qty;
        productlist![i].myVariantId = myVariantId;
        // print('qty is -----$Qty');
        setState(() {});
        break;
      }
    }
  }
  // onCallBack(String House, String Apartment, String id) async {
  //   for(int i = 0; i <  addresslist!.length; i++){
  //     if(addresslist![i].id.toString() == id.toString()){
  //       addresslist![i].house = House;
  //       addresslist![i].apartment = Apartment;
  //       setState(() {});
  //       break;
  //     }
  //   }
  // }

  setValue() {
    for (int i = 0; i < productlist!.length; i++) {
      productlist![i].price = productlist![i].variant!.first.price;
      productlist![i].myVariantId = productlist![i].variant!.first.id;
      productlist![i].itemCount = productlist![i].variant!.first.qty.toString();
      setState(() {});
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
                      widget.vendorName,
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
            SizedBox(
              height: 80.0,
              child: serviceslist!.isEmpty
                  ? Center(
                      child: Text(
                      'no services added yet !',
                      style: TextStyle(color: AppColors.secondaryColor),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          serviceslist!.length < 0 ? 1 : serviceslist!.length,
                      itemBuilder: (context, index) {
                        return serviceslist!.length < 0
                            ? Center(
                                child: Text(
                                'no services added yet !',
                                style:
                                    TextStyle(color: AppColors.secondaryColor),
                              ))
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      vendorsproductapi(context, serviceslist![index].id!,true);
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
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
                                            Urls.imageUrl + serviceslist![index].image.toString(),
                                            width: 32.0,
                                          ),
                                        ),
                                        Text(
                                          serviceslist![index].name.toString(),
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
            productlist!.isEmpty
                ? Center(
                    child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Text(
                      'No Products added yet !',
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
                      childAspectRatio: 8 / 16,
                    ),
                    itemCount:
                        productlist!.length < 0 ? 1 : productlist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      int myCount =
                          int.parse(productlist![index].itemCount.toString());
                      return productlist!.length < 0
                          ? Center(
                              child: Text(
                              'Not Products added yet !',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ))
                          : Padding(
                              padding: EdgeInsets.only(
                                top: 20.0,
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
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                            child: ProductDetail(
                                                productId:
                                                    productlist![index].id!),
                                          ),
                                        );
                                      },
                                      child: Image.network(
                                        Urls.imageUrl +
                                            productlist![index]
                                                .image
                                                .toString(),
                                        height: 94.0,
                                      ),
                                    ),
                                    Text(
                                      '\$${productlist![index].price}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.activeDotsColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      productlist![index].title.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: SizedBox(
                                        height: 40.0,
                                        child: SearchFilter(
                                          variantlist:
                                              productlist![index].variant,
                                          onCallBack: onCallBack,
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFEBEBEB),
                                      // color: Colors.black,
                                    ),
                                    myCount == 0
                                        ? InkWell(
                                            onTap: () {
                                              int priceIncrease = int.parse(productlist![index].itemCount.toString());
                                              priceIncrease++;
                                              productlist![index].itemCount = priceIncrease.toString();
                                              addtocartapi2(context,productlist![index].id.toString(),productlist![index].myVariantId.toString(),productlist![index].itemCount.toString());
                                              setState(() {});
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.0,
                                                  vertical: 6.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/icons/add_to_cart.svg',
                                                    width: 15.0,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Text(
                                                      'Add to cart',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .appBlackColor,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  int priceDecrease = int.parse(
                                                      productlist![index]
                                                          .itemCount
                                                          .toString());
                                                  if (priceDecrease == 1) {
                                                    priceDecrease--;
                                                    productlist![index]
                                                            .itemCount =
                                                        priceDecrease
                                                            .toString();
                                                    addtocartapi2(context,productlist![index].id.toString(),productlist![index].myVariantId.toString(),productlist![index].itemCount.toString());
                                                    setState(() {});
                                                  } else {
                                                    priceDecrease--;
                                                    productlist![index]
                                                            .itemCount =
                                                        priceDecrease
                                                            .toString();
                                                    addtocartapi2(context,productlist![index].id.toString(),productlist![index].myVariantId.toString(),productlist![index].itemCount.toString());
                                                    setState(() {});
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    '-',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 20.0),
                                                  ),
                                                ),
                                              ),
                                              Text(productlist![index]
                                                  .itemCount
                                                  .toString()),
                                              InkWell(
                                                onTap: () {
                                                  int priceIncrease = int.parse(
                                                      productlist![index]
                                                          .itemCount
                                                          .toString());
                                                  priceIncrease++;
                                                  productlist![index]
                                                          .itemCount =
                                                      priceIncrease.toString();
                                                  addtocartapi2(context,productlist![index].id.toString(),productlist![index].myVariantId.toString(),productlist![index].itemCount.toString());
                                                  setState(() {});
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    '+',
                                                    style: TextStyle(
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize: 20.0),
                                                  ),
                                                ),
                                              ),
                                            ],
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
      bottomNavigationBar: cartStatus == false
          ? Container(
              width: 1,
              height: 1,
              child: Text(
                'd',
                style: TextStyle(color: Colors.transparent),
              ))
          : Padding(
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
                        duration: Duration(milliseconds: 1000),
                        isIos: true,
                        child: Dashboard(bottomIndex: 2),
                      ),
                    ).then((value){
                      vendorsproductapi(context, 0,true);
                      getcartapi(context, 0);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cartSubTotal == null ? '\$0.00' : '\$$cartSubTotal',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${getcartitemslist!.length} Items',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'View Cart',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // vendors api
  Future<void> vendorsproductapi(BuildContext context, int productCategoryId, bool showLoader) async {

    if(showLoader == true){
      Loader.showAlertDialog(context, true);
    }else{

    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['vendor_id'] = widget.vendorId;
    request['product_category_id'] = productCategoryId;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.vendorsProductUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization": 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    if(showLoader == true){
      Loader.showAlertDialog(context, false);
    }else{

    }
    VendorsProductModel res = await VendorsProductModel.fromJson(jsonResponse);
    if (res.status == true) {
      serviceslist!.clear();
      productlist!.clear();
      serviceslist = res.data!.services;
      productlist = res.data!.products;
      setValue();
      setState(() {});
    } else {
      UtilityToaster().getToast(res.message);
      setState(() {});
    }
    return;
  }



  // add to cart api
  // add to cart api
  Future<void> addtocartapi2(BuildContext context, String productId,String variantId, String qty) async {
    Loader.showAlertDialog(context, true);
    int intqty = int.parse(qty.toString());
    int? apiIntqty;
    if(intqty == 0){
      apiIntqty = 0;
    }else{
      apiIntqty = intqty;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['product_id'] = productId;
    request['variant_id'] = variantId;
    request['qty'] = apiIntqty;
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
      vendorsproductapi(context, 0,false);
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
  // get cart api
  Future<void> getcartapi(BuildContext context, int addressId) async {
    getcartitemslist!.clear();
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
      cartStatus = res.status;
      cartSubTotal = res.data!.cartTotal!.subtotal.toString();
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
}

class SearchFilter extends StatefulWidget {
  List<Variant>? variantlist;
  Function onCallBack;
  SearchFilter(
      {super.key, required this.variantlist, required this.onCallBack});

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  String dropdownValue = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.variantlist!.first.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        border: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      ),
      value: dropdownValue,
      style: TextStyle(color: AppColors.secondaryColor),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: List.generate(
          widget.variantlist!.length,
          (index) => DropdownMenuItem(
                onTap: () {
                  widget.onCallBack(
                      widget.variantlist![index].id,
                      widget.variantlist![index].qty.toString(),
                      widget.variantlist![index].price.toString(),
                      widget.variantlist![index].productId.toString());
                },
                child: Text(widget.variantlist![index].perWeight.toString()),
                value: widget.variantlist![index].id.toString(),
              )),
      onChanged: (String? value) {
        dropdownValue = value.toString();
        setState(() {});
      },
    );
  }
}
