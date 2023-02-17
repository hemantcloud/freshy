// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:freshy/views/utilities/toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyRegister extends StatefulWidget {
  const VerifyRegister({Key? key}) : super(key: key);

  @override
  State<VerifyRegister> createState() => _VerifyRegisterState();
}

class _VerifyRegisterState extends State<VerifyRegister> {
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

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
                  onChanged: (value) {},
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
                  onTap: () {
                    String otp = otpController.text;
                    if (otp.isEmpty) {
                      UtilityToaster().getToast("Please Enter Otp.");
                    } else if (otp.length < 6 || otp.length > 6) {
                      UtilityToaster().getToast("Please Enter Valid Otp.");
                    } else {
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
}
