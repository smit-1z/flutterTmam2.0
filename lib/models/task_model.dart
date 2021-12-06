import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModels {
  String? id = "", task = "", priority = "";
  Timestamp? createdTime;
  String? date = "", time = "";

  TaskModels(
      {this.id,
      this.createdTime,
      this.date,
      this.priority,
      this.task,
      this.time});

  static TaskModels fromMap(Map<String, dynamic> map) {
    String? id = "", task = "", priority = "";
    Timestamp? createdTime;
    String? date = "", time = "";

    id = map['id'] != null ? map['id'] : "";
    task = map['task'] != null ? map['task'] : "";
    priority = map['priority'] != null ? map['priority'] : "";
    date = map['date'] != null ? map['date'] : "";
    time = map['time'] != null ? map['time'] : "";
    createdTime = map['createdTime'];

    return TaskModels(
        id: id,
        date: date,
        priority: priority,
        task: task,
        time: time,
        createdTime: createdTime,
     );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id ?? '',
      "task": task ?? '',
      "time": time ?? '',
      "priority": priority ?? '',
      "date": date ?? '',
      "createdtime": createdTime,
    };
  }
}
