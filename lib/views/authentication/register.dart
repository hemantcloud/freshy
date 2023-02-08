// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:freshy/models/register_model.dart';
import 'package:freshy/views/authentication/verify_register.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
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

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static String? verify;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var countrycodecontroller = new TextEditingController();
  String devicetype = '';
  String deviceid = '';
  String text = "Loading...";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInfo();
  }
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
                child: Text(
                  'Register',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 2.0),
                alignment: Alignment.center,
                child: Text(
                  'Quickly Setup account',
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 15.0,
                  ),
                ),
              ),
              Container(
                height: 60.0,
                margin: EdgeInsets.fromLTRB(20.0, 26.0, 20.0, 0.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        'assets/icons/profile_selected.svg',
                        width: 20.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        // textAlignVertical: TextAlignVertical.bottom,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        cursorColor: AppColors.secondaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
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
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
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
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontSize: 14.0, color: AppColors.secondaryColor),
                        cursorColor: AppColors.secondaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
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
                margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 0.0),
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                          exclude: <String>['KN', 'MF'],
                          //Optional. Shows phone code before the country name.
                          showPhoneCode: true,
                          favorite: ['+91','IN'],
                          onSelect: (Country country) {
                            print('Selected country: ${country.phoneCode}');
                            countrycodecontroller.text = '+${country.phoneCode}';
                            setState(() {});
                          },
                        );
                      },
                      child: Container(
                        width: 45.0,
                        height: 30.0,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: countrycodecontroller,
                          enabled: false,
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Poppins',
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: '+91',
                            fillColor: AppColors.secondaryColor,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          // Only numbers can be entered
                        ),
                      ),
                    ),
                    /*Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: SvgPicture.asset(
                        'assets/icons/phone.svg',
                        width: 23.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),*/
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        // textAlignVertical: TextAlignVertical.bottom,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(
                          fontSize: 14.0,
                          // fontFamily: 'Poppins',
                          color: AppColors.secondaryColor,
                        ),
                        maxLength: 10,
                        cursorColor: AppColors.secondaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Phone number',
                          hintStyle: TextStyle(
                            fontSize: 14.0,
                            color: AppColors.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          counterText: "",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 69.0),
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
                    String name = nameController.text;
                    String email = emailController.text;
                    String phone = phoneController.text;
                    if(name.isEmpty){
                      UtilityToaster().getToast("Please Enter Name.");
                    } else if(email.isEmpty){
                      UtilityToaster().getToast('Plase enter name');
                    }else if(!email.contains('@gmail.com')){
                      UtilityToaster().getToast("Please Enter Valid Email Address.");
                    }else if(phone.isEmpty){
                      UtilityToaster().getToast("Please Enter Phone Number.");
                    }else if(phone.length < 10 || phone.length > 10){
                      UtilityToaster().getToast("Please Enter Valid Phone Number.");
                    }else{
                      String? countryCodeApi;
                      if(countrycodecontroller.text.isEmpty){
                        countryCodeApi = '+91';
                      }else{
                        countryCodeApi = countrycodecontroller.text;
                      }
                      FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.verifyPhoneNumber(
                        phoneNumber: '$countryCodeApi${phoneController.text}',
                        verificationCompleted: (PhoneAuthCredential credential) async {
                          await auth.signInWithCredential(credential);
                        },
                        verificationFailed: (FirebaseAuthException error) { print('error is ------------$error'); },
                        codeSent: (String verificationId, int? forceResendingToken) {
                          Register.verify = verificationId;
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              alignment: Alignment.topCenter,
                              duration: Duration(milliseconds: 1000),
                              isIos: true,
                              child: VerifyRegister(
                                name: nameController.text,
                                email: emailController.text,
                                countryCode: countryCodeApi.toString(),
                                phone: phoneController.text,
                                deviceType: devicetype,
                                deviceId: deviceid,
                                fcmToken: 'fcm_token'
                              ),
                            ),
                          );
                          print('$countryCodeApi${phoneController.text} is ---------------------$countryCodeApi${phoneController.text}');
                          UtilityToaster().getToast("OTP has been sent to your mobile number.");
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {  },
                      );
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 21.0),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Already have an account ? '),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => {
                            Navigator.pop(context)
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// loads device info
  void loadInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
      print('Web - Running on ${webBrowserInfo.userAgent}');
      setState(() {
        text = webBrowserInfo.toMap().toString();
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('iOS - Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      deviceid = iosInfo.model.toString();
      devicetype = 'ios';
      setState(() {
        text = iosInfo.toMap().toString();
      });
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Android - Running on ${androidInfo.id}'); // e.g. "Moto G (4)"
      print('androidInfo.model -------${androidInfo.model}');
      print('androidInfo.type -------${androidInfo.type}');
      print('androidInfo.device -------${androidInfo.device}');
      print('androidInfo.board -------${androidInfo.board}');
      print('androidInfo.bootloader -------${androidInfo.bootloader}');
      print('androidInfo.brand -------${androidInfo.brand}');
      print('androidInfo.display -------${androidInfo.display}');
      print('androidInfo.fingerprint -------${androidInfo.fingerprint}');
      print('androidInfo.hardware -------${androidInfo.hardware}');
      print('androidInfo.host -------${androidInfo.host}');
      print('androidInfo.isPhysicalDevice -------${androidInfo.isPhysicalDevice}');
      print('androidInfo.manufacturer -------${androidInfo.manufacturer}');
      print('androidInfo.product -------${androidInfo.product}');
      print('androidInfo.tags -------${androidInfo.tags}');
      deviceid = androidInfo.id;
      devicetype = 'android';
      setState(() {
        text = androidInfo.toMap().toString();
      });
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      print(windowsInfo.toMap().toString());
      setState(() {
        text = windowsInfo.toMap().toString();
      });
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOSInfo = await deviceInfo.macOsInfo;
      print(macOSInfo.toMap().toString());
      setState(() {
        text = macOSInfo.toMap().toString();
      });
    } else if (Platform.isLinux) {
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      print(linuxInfo.toMap().toString());
      setState(() {
        text = linuxInfo.toMap().toString();
      });
    }
  }
}
