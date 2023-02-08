import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshy/views/authentication/login.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/onboarding.dart';
import 'package:freshy/views/welcome_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool initScreen = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allProcess();
  }

  Future<void> allProcess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if(prefs.getBool('initScreen') == null || prefs.getBool('initScreen') == false || prefs.getBool('initScreen') == ''){
      Timer(const Duration(seconds: 2),() {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 500),
            isIos: true,
            child: Onboarding(),
          ),
        );
      });
    }else{
      Timer(const Duration(seconds: 2),() {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            alignment: Alignment.topCenter,
            duration: Duration(milliseconds: 500),
            isIos: true,
            child:
            prefs.getBool('isLogin') == true ?
            Dashboard(bottomIndex: 0) : Login(),
          ),
        );
      });
    }
    prefs.setBool('initScreen', true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/splash_bg.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        /*child: Image.asset(
          'assets/images/splash_logo.png',
        ),*/
        child: Center(
          child: Image.asset(
            'assets/images/main_logo2.png',
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ),
      ),
    );
  }
}
