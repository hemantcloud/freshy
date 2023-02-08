// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/logout_model.dart';
import 'package:freshy/models/profile_model.dart';
import 'package:freshy/views/account/my_addresses.dart';
import 'package:freshy/views/account/edit_profile.dart';
import 'package:freshy/views/authentication/login.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/policies/privacy_policy.dart';
import 'package:freshy/views/policies/tnc.dart';
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

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late SharedPreferences prefs;
  late String auth_token;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profileapi(context);
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
                      'Profile',
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
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/profile.png',
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {},
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: SvgPicture.asset(
                                'assets/icons/camera.svg',
                                height: 15.0,
                                width: 15.0,
                                color: AppColors.activeDotsColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    user == null ? '' : "${user!.name.toString()[0].toUpperCase()}${user!.name.toString().substring(1).toLowerCase()}",
                    // user == null ? '' : user!.name.toString().toUpperCase(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    user == null ? '' : user!.email.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeftWithFade,
                          alignment: Alignment.topCenter,
                          duration: Duration(milliseconds: 1000),
                          isIos: true,
                          child: EditProfile(profileModel: user!,),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/edit_profile.svg',
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
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
                          child: Dashboard(bottomIndex: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/my_orders.svg',
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'My Orders',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
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
                          child: MyAddresses(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/my_addresses.svg',
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'My Addresses',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
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
                          child: TNC(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/term_and_condition.svg',
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Terms & Condition',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
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
                          child: PrivacyPolicy(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/privacy_policy.svg',
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      logoutapi(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/logout.svg'),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          SvgPicture.asset(
                            'assets/icons/forward.svg',
                            width: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // logout api
  Future<void> logoutapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.logoutUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization" : 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    LogoutModel responselogout = await LogoutModel.fromJson(jsonResponse);
    if(responselogout.status == true){
      prefs.setString('auth_token','');
      prefs.setBool('isLogin',false);
      UtilityToaster().getToast(responselogout.message);
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 1000),
          isIos: true,
          child: Login(),
        ),
            (route) => false,
      );
      setState(() {});
    }else{
      UtilityToaster().getToast(responselogout.message);
      setState(() {});
    }
    return;
  }
  // logout api
  // profile api
  Future<void> profileapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.profileUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization" : 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    ProfileModel responseprofile = await ProfileModel.fromJson(jsonResponse);
    if(responseprofile.status == true){
      user = responseprofile.data!.user;
      setState(() {});
    }else{
      UtilityToaster().getToast(responseprofile.message);
      setState(() {});
    }
    return;
  }
  // profile api
}
