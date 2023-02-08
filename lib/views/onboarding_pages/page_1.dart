// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:freshy/views/utilities/app_colors.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/bag.png',
            ),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
          ),
          color: Color(0xFFECEEEB),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.08),
              Text(
                'Welcome to Freshy',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Image.asset(
                'assets/images/main_logo2.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.secondaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
