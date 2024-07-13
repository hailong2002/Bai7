import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timesheet/data/repository/auth_repo.dart';

import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import '../model/body/user.dart';

class UserRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  UserRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> updateMyself({required String firstName,
    required String lastName, required String email, required String universityName,
    required String gender, required DateTime dob, required int studentYear,
    required String username, required String password, required String confirmPassword})
    async{
      var token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
      var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=2D15EBBD50AE0B630911916C2C89241E',
        AppConstants.LOCALIZATION_KEY:
        languageCode ?? AppConstants.languages[0].languageCode,
        'Authorization': token
      };
      return await apiClient.postData(
          AppConstants.UPDATE_MYSELF,
          {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'university': universityName,
            'gender': gender,
            'dob': dob.toIso8601String(),
            'year': studentYear,
            "active": true,
            'username': username,
            'password': password,
            'displayName': username,
            'confirmPassword': confirmPassword
          }, _header);
    }

  Future<Response> getAllTrackingOfUser() async{
    var token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=2D15EBBD50AE0B630911916C2C89241E',
      AppConstants.LOCALIZATION_KEY:
      languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    return await apiClient.getData(
        AppConstants.TRACKING,
        headers: _header
    );
  }

  Future<Response> fillTracking({required String content, required User user}) async{
    var token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=2D15EBBD50AE0B630911916C2C89241E',
      AppConstants.LOCALIZATION_KEY:
      languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };

    return await apiClient.postData(
        AppConstants.TRACKING,
        {
          'content': content,
          'date': DateTime.now().toIso8601String(),
          'user': user
        },
        _header);
  }

  Future<Response> updateTracking({required String content, required User user,
    required DateTime? date, required int id}) async{
      var token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
      var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
      Map<String, String> _header = {
        'Content-Type': 'application/json',
        'Cookie': 'JSESSIONID=2D15EBBD50AE0B630911916C2C89241E',
        AppConstants.LOCALIZATION_KEY:
        languageCode ?? AppConstants.languages[0].languageCode,
        'Authorization': token
      };
      print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
      return await apiClient.postData(
          '${AppConstants.TRACKING}/$id',
          {
            'content': content,
            'date': date!.toIso8601String(),
            'user': user,
            'id': id
          },
          _header);

  }

  Future<Response> deleteTracking({ required int id}) async{
    var token = sharedPreferences.getString(AppConstants.TOKEN) ?? "";
    var languageCode = sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
    Map<String, String> _header = {
      'Content-Type': 'application/json',
      'Cookie': 'JSESSIONID=2D15EBBD50AE0B630911916C2C89241E',
      AppConstants.LOCALIZATION_KEY:
      languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': token
    };
    return await apiClient.deleteData(
      '${AppConstants.TRACKING}/$id',
      headers: _header
    );
  }


}