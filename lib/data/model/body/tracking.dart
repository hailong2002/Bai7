import 'package:timesheet/data/model/body/user.dart';

class Tracking {
  int? id;
  String? content;
  String? date;
  User? user;

  Tracking({this.id,this.content, this.date, this.user});

  Tracking.fromJson(Map<String, dynamic> json){
    id = json['id'];
    content = json['content'];
    date = json['date'];
    user = User.fromJson(json['user']);
  }





}

