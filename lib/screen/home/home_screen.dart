import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/auth_controller.dart';
import 'package:timesheet/screen/account/account_screen.dart';
import 'package:timesheet/screen/home/check_in_screen.dart';
import 'package:timesheet/screen/home/tracking_screen.dart';
import 'package:timesheet/screen/sign_in/sign_in_screen.dart';

import '../../controller/user_controller.dart';
import '../../data/model/body/tracking.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  List<Widget> screens = const [
    HomeScreen(),
    AccountScreen(),
  ];
  
  void _moveScreen(int index){
    setState(()=> _index = index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _index == 0 ?
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _logout,
                      child: const Text('Đăng xuất')),
                  ElevatedButton(
                      onPressed: ()=> Get.to(const TrackingScreen(),transition: Transition.size,duration: const Duration(milliseconds: 500),curve: Curves.easeIn),
                      child: const Text("Tracking")),
                  ElevatedButton(
                      onPressed: ()=> Get.to(const CheckInScreen(),transition: Transition.size,duration: const Duration(milliseconds: 500),curve: Curves.easeIn),
                      child: const Text("Checkin")),
                ],
              ),
            )
          : screens.elementAt(_index),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _index,
        onTap: _moveScreen,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ', ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_sharp), label: 'Tài khoản'),
        ],
      ),
    );
  }

  _logout(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Xác nhận đăng xuất'),
            content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: [
              ElevatedButton(
                  onPressed: ()=>Navigator.pop(context),
                  child: const Text('Hủy')
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: (){
                    Get.find<AuthController>().logOut();
                    Get.to(const SignInScreen(),transition: Transition.size,duration:const  Duration(milliseconds: 500),curve: Curves.easeIn);
                    },
                  child: const Text('Đăng xuất')
              )
            ],
          );
        }
    );
  }

}
