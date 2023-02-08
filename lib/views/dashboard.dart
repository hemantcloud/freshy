import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshy/views/home/home.dart';
import 'package:freshy/views/orders/my_order.dart';
import 'package:freshy/views/product/cart.dart';
import 'package:freshy/views/account/profile.dart';
class Dashboard extends StatefulWidget {
  int bottomIndex;
  Dashboard({Key? key, required this.bottomIndex}) : super(key: key);
  @override
  State<Dashboard> createState() => _HomeState();
}
var widgetOptions = [
  Home(),
  const MyOrders(),
  Cart(),
  Profile(),
];


class _HomeState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {

    void _onItemTapped(int index) {
      setState(() {
        widget.bottomIndex = index;
        // print("index>>>>${_selectedIndex}");
      });
    }
    return Scaffold(
      body: widgetOptions[
      widget.bottomIndex
      ],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: widget.bottomIndex == 0 ?
              SvgPicture.asset('assets/icons/home_selected.svg',width: 20.0,height: 20.0,) :
              SvgPicture.asset('assets/icons/home_unselected.svg',width: 20.0,height: 20.0,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: widget.bottomIndex == 1 ?
            SvgPicture.asset('assets/icons/bag_selected.svg',width: 20.0,height: 20.0,) :
            SvgPicture.asset('assets/icons/bag_unselected.svg',width: 20.0,height: 20.0,),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: widget.bottomIndex == 2 ?
            SvgPicture.asset('assets/icons/cart_selected.svg',width: 20.0,height: 20.0,) :
            SvgPicture.asset('assets/icons/cart_unselected.svg',width: 20.0,height: 20.0,),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: widget.bottomIndex == 3 ?
            SvgPicture.asset('assets/icons/profile_selected.svg',width: 20.0,height: 20.0,) :
            SvgPicture.asset('assets/icons/profile_unselected.svg',width: 20.0,height: 20.0,),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.bottomIndex,
        elevation: 0.0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.yellow,
        onTap: _onItemTapped,
      ),
    );
  }
}
