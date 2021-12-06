import 'package:authentification/models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id = "", name = "", email = "";
  Timestamp? createdTime;
  List<TaskModels>? taskList = [];


  UserModel({this.id, this.name, this.createdTime, this.email,this.taskList});


  static UserModel fromMap(Map<String,dynamic> map){
    String? id = "", name = "", email = "";
    Timestamp? createdTime;
    List<TaskModels>? taskList = [];


    id = map['id'] != null ? map['id'] : "";
    name = map['name'] != null ? map['name'] : "";
    email = map['email'] != null ? map['email'] : "";
    createdTime = map['createdTime'];
    List<Map<String, dynamic>> taskMapList =
    List.castFrom(map['tasks'] ?? []);
    taskList = [];
    taskList.addAll(taskMapList.map((e) => TaskModels.fromMap(e)).toList());


    return UserModel(
      id: id,
      taskList: taskList,
      name: name,
      createdTime: createdTime,
      email: email
    );
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id ?? "";
    data["name"] = name ?? "";
    data["email"] = email ?? "";
    data["createdTime"] = createdTime;
    List<Map<String, dynamic>> tasksMapsList = [];
    tasksMapsList.addAll((taskList ?? []).map((e) => e.toMap()).toList());
    data['tasks'] = tasksMapsList;

    return data;
  }

}
