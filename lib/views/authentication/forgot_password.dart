// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/views/authentication/login.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 1000),
                            isIos: true,
                            child: Login(),
                          ),
                        );
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
                          'Password Recovery',
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
                padding: EdgeInsets.only(left: 16.0, top: 85.0),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 13.0,
                  left: 20.0,
                  right: 20.0,
                ),
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                height: 60.0,
                margin: EdgeInsets.fromLTRB(20.0, 67.0, 20.0, 0.0),
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
                        'assets/icons/message.svg',
                        width: 23.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: emailAddressController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 14.0, color: AppColors.secondaryColor),
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
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        alignment: Alignment.topCenter,
                        duration: Duration(milliseconds: 500),
                        isIos: true,
                        child: Login(),
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Send Link',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
