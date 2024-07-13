import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/data/api/api_client.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/screen/account/update_info_screen.dart';

import '../../controller/auth_controller.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().getCurrentUser();
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            children: [
              const Text('Thông tin cá nhân',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Username: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Email: ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Họ: ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Tên: ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Ngày sinh: ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Tên trường:  ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Sinh viên năm: ', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                      Text('Giới tính: ',maxLines: 3, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${controller.user.username}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.email}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.lastName}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.firstName}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.dob}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.university}',style: const TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis),
                      Text('${controller.user.year}',style: const TextStyle(fontSize: 20)),
                      Text('${controller.user.gender}',style: const TextStyle(fontSize: 20)),

                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: ()=> Get.to(const UpdateInfoScreen(),transition: Transition.size,duration: const Duration(milliseconds: 500),curve: Curves.easeIn),
                  child: const Text('Thay đổi',style:TextStyle(fontSize: 18))
              )
            ],
          ),
        );
      },
    );


  }
}
