// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freshy/models/login_model.dart';
import 'package:freshy/views/authentication/login.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// apis
import 'dart:io';
import 'dart:async';
import 'dart:convert' as convert;
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:freshy/views/utilities/custom_loader.dart';
import 'package:freshy/views/utilities/toast.dart';
import 'package:freshy/views/utilities/urls.dart';
// apis

class VerifyLogin extends StatefulWidget {
  String phone;
  String countryCode;
  String deviceType;
  String deviceId;
  String fcmToken;
  VerifyLogin({Key? key,required this.phone,required this.countryCode,required this.deviceType,required this.deviceId,required this.fcmToken}) : super(key: key);
  @override
  State<VerifyLogin> createState() => _VerifyLoginState();
}

class _VerifyLoginState extends State<VerifyLogin> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String? code;
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 56.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/main_logo2.png',
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 20.0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'Verify your number',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 13.0, left: 20.0, right: 20.0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'Enter your OTP code below',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 67.0),
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Color(0xff254d71),
                    fontWeight: FontWeight.bold,
                  ),
                  length: 6,
                  obscureText: true,
                  obscuringCharacter: '•',
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {},
                  backgroundColor: Colors.transparent,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    fieldHeight: 50,
                    fieldWidth: 50,
                    activeFillColor: Colors.white,
                    inactiveColor: AppColors.secondaryColor,
                    inactiveFillColor: AppColors.primaryColor,
                    borderWidth: 1.2,
                    activeColor: AppColors.primaryColor,
                    selectedColor:
                        AppColors.primaryColor, // single box border color
                  ),
                  cursorColor: AppColors.primaryColor,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  errorAnimationController: errorController,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    code = value;
                    print(value);
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    return true;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 13.0, left: 20.0, right: 20.0),
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
                  onTap: () async {
                    String otp = otpController.text;
                    if (otp.isEmpty) {
                      UtilityToaster().getToast("Please Enter Otp.");
                    } else if (otp.length < 6 || otp.length > 6) {
                      UtilityToaster().getToast("Please Enter Valid Otp.");
                    } else {
                      try{
                        FirebaseAuth auth = FirebaseAuth.instance;
                        // Create a PhoneAuthCredential with the code
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Login.verify.toString(), smsCode: code.toString());

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);
                        loginapi(context);
                      }catch(e){
                        print('error is -----------$e');
                        UtilityToaster().getToast('Something went wrong');
                      }
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 17.0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'Did’nt receive the code ?',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Resend a new code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // loginapi api
  Future<void> loginapi(BuildContext context) async {
    Loader.ProgressloadingDialog(context, true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = {};
    request['phone'] = widget.phone;
    request['country_code'] = widget.countryCode;
    request['device'] = widget.deviceType;
    request['device_id'] = widget.deviceId;
    request['fcm_token'] = widget.fcmToken;
    HttpWithMiddleware http = HttpWithMiddleware.build(middlewares: [
      HttpLogger(logLevel: LogLevel.BODY),
    ]);
    var response = await http.post(Uri.parse(Urls.loginUrl),
        body: convert.jsonEncode(request),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        });
    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    Loader.ProgressloadingDialog(context, false);
    LoginModel responseLogin = await LoginModel.fromJson(jsonResponse);
    if (responseLogin.status == true) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          alignment: Alignment.topCenter,
          duration: Duration(milliseconds: 1000),
          isIos: true,
          child: Dashboard(bottomIndex: 0),
        ),
      );
      UtilityToaster().getToast(responseLogin.message);
      prefs.setString('auth_token', responseLogin.data!.token.toString());
      prefs.setBool('isLogin', true);
    } else {
      UtilityToaster().getToast(responseLogin.message.toString());
    }
    return;
  }
// loginapi api
}
