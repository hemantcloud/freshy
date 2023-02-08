// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/profile_model.dart';
import 'package:freshy/models/update_profile_model.dart';
import 'package:freshy/views/dashboard.dart';
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

class EditProfile extends StatefulWidget {
  User profileModel;
  EditProfile({Key? key, required this.profileModel}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late String auth_token;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
    all_process();
  }
  Future<void> all_process() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    auth_token = prefs.getString('auth_token')!;
    print('my auth token is ----------------{$auth_token}');
    setState(() {});
  }
  ///Set data controller...............
  setData() {
    nameController.text = widget.profileModel.name!.isNotEmpty
        ? widget.profileModel.name.toString()
        : '';
    emailController.text = widget.profileModel.email!.isNotEmpty
        ? widget.profileModel.email.toString()
        : '';
    phoneController.text = widget.profileModel.phone!.isNotEmpty
        ? widget.profileModel.phone.toString()
        : '';
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
                      'About me',
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
              margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Personal Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
              ),
            ),
            Container(
              height: 60.0,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 0.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/profile_circle.svg',
                      width: 23.0,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(fontSize: 14.0, color: AppColors.secondaryColor),
                      cursorColor: AppColors.secondaryColor,
                      decoration: const InputDecoration(
                        hintText: 'Your Name',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
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
            Container(
              height: 60.0,
              margin: EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 0.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: SvgPicture.asset(
                      'assets/icons/mail.svg',
                      width: 20.0,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 14.0, color: AppColors.secondaryColor),
                      cursorColor: AppColors.secondaryColor,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
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
            Container(
              height: 60.0,
              margin: EdgeInsets.only(top: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 0.0),
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: SvgPicture.asset(
                      'assets/icons/phone.svg',
                      width: 23.0,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontSize: 14.0, color: AppColors.secondaryColor),
                      cursorColor: AppColors.secondaryColor,
                      maxLength: 10,
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: '+1  202  555  0142 ',
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(20.0),
        child: InkWell(
          onTap: () {
            String name = nameController.text;
            String email = emailController.text;
            String phone = phoneController.text;
            if (name.isEmpty) {
              UtilityToaster().getToast("Please Enter Name.");
            } else if (email.isEmpty) {
              UtilityToaster().getToast('Plase enter name');
            } else if (!email.contains('@gmail.com')) {
              UtilityToaster().getToast("Please Enter Valid Email Address.");
            } else if (phone.isEmpty) {
              UtilityToaster().getToast("Please Enter Phone Number.");
            } else if (phone.length < 10 || phone.length > 10) {
              UtilityToaster().getToast("Please Enter Valid Phone Number.");
            }else{
              updateprofileapi(context);
            }
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
              'Save settings',
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
  // profile api
  Future<void> updateprofileapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? auth_token = prefs.getString('auth_token');
    var request = {};
    request['name'] = nameController.text;
    request['email'] = emailController.text;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.updateProfileUrl),
        body: convert.jsonEncode(request),
        headers: {
          "content-type": "application/json",
          "accept": "application/json",
          "Authorization" : 'Bearer ${auth_token}',
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    UpdateProfileModel responseupdateprofile = await UpdateProfileModel.fromJson(jsonResponse);
    if(responseupdateprofile.status == true){
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 1000),
          isIos: true,
          child: Dashboard(bottomIndex: 3),
        ),
        (route) => false,
      );
      setState(() {});
    }else{
      UtilityToaster().getToast(responseupdateprofile.message);
      setState(() {});
    }
    return;
  }
// profile api
}
