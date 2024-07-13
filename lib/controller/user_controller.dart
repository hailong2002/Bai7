import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:timesheet/data/model/body/tracking.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/user.dart';
import '../data/repository/user_repo.dart';
import 'auth_controller.dart';

class UserController extends GetxController implements GetxService{
  final UserRepo repo;

  UserController({required this.repo});

  // bool _loading = false;
  // User _user = User();
  //
  //
  // bool get loading => _loading;
  // User get user => _user;
  Tracking _tracking = Tracking();
  Tracking get tracking => _tracking;
  List<Tracking> _trackingList = [];
  List<Tracking> get trackingList => _trackingList;


  Future<int> updateMyself({ required String firstName,
    required String lastName, required String email, required String universityName,
    required String gender, required DateTime dob, required int studentYear,
    required String username, required String password, required String confirmPassword})
    async{
      Response response = await repo.updateMyself(
          firstName: firstName,
          lastName: lastName,
          email: email,
          universityName: universityName,
          gender: gender,
          dob: dob,
          studentYear: studentYear,
          username: username,
          password: password,
          confirmPassword: confirmPassword);
      if(response.statusCode == 200){
        Get.find<AuthController>().getCurrentUser();
        update();
      }
      else {
        ApiChecker.checkApi(response);
      }
      return response.statusCode!;

   }

  Future<int> getAllTracking() async{
    Response response = await repo.getAllTrackingOfUser();
    if(response.statusCode == 200){
      var listTracking = response.body as List;
      _trackingList = listTracking.map((json)=> Tracking.fromJson(json)).toList();
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    return response.statusCode!;
  }


  Future<int> fillTracking({required String content, required User user}) async{
      Response response = await repo.fillTracking(content: content, user: user);
      if(response.statusCode == 200){
        print('fill thành công');
        update();
        getAllTracking();
      } else {
        ApiChecker.checkApi(response);
      }
      return response.statusCode!;
   }

   Future<int> updateTracking({required String content, required User user,
    required int id, required DateTime? date}) async{
      Response response = await repo.updateTracking(content: content, user: user, date: date, id: id);
      if(response.statusCode == 200){
        print('Update thành công');
        update();
        getAllTracking();
      } else {
        ApiChecker.checkApi(response);
      }
      return response.statusCode!;
   }

   Future<int> deleteTracking({required int id}) async{
      Response response = await repo.deleteTracking(id: id);
      if(response.statusCode == 200){
        print('Delete thành công');
        update();
        getAllTracking();
      } else {
        ApiChecker.checkApi(response);
      }
      return response.statusCode!;

   }

}