// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:freshy/views/authentication/login.dart';
import 'package:freshy/views/dashboard.dart';
import 'package:freshy/views/utilities/app_colors.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:freshy/views/onboarding_pages/page_1.dart';
import 'package:freshy/views/onboarding_pages/page_2.dart';
import 'package:freshy/views/onboarding_pages/page_3.dart';

class Onboarding extends StatefulWidget {
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final _controller = PageController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentIndex == 0 ? Color(0xFFECEEEB) : Colors.white,
      body: Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // page view
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  _currentIndex = index;
                  // print('_currentIndex index is---------$_currentIndex');
                  setState(() {});
                },
                reverse: false,
                children: const [
                  Page1(),
                  Page2(),
                  Page3(),
                ],
              ),
            ),

            // dot indicators
            Stack(
              children: [
                SmoothPageIndicator(
                  onDotClicked: (index) {
                    _controller.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  controller: _controller,
                  count: 3,
                  effect: ScrollingDotsEffect(
                    activeStrokeWidth: 2.6,
                    activeDotScale: 1.3,
                    maxVisibleDots: 5,
                    radius: 8,
                    spacing: 10,
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: AppColors.activeDotsColor,
                    dotColor: AppColors.dotsColor,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
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
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  _currentIndex == 2
                      ? Navigator.pushReplacement(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            alignment: Alignment.topCenter,
                            duration: Duration(milliseconds: 500),
                            isIos: true,
                            child: prefs.getBool('isLogin') == true
                                ? Dashboard(bottomIndex: 0)
                                : Login(),
                          ),
                        )
                      : _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    _currentIndex == 2 ? 'Get Started' : 'Next',
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
    );
  }
}
