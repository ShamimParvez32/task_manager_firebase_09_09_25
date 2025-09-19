import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';

class NewTaskListByStatusModel {
  String? status;
  List<TaskModel>? newTaskModelList;

  NewTaskListByStatusModel({this.status, this.newTaskModelList});

  NewTaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      newTaskModelList = <TaskModel>[];
      json['data'].forEach((v) {
        newTaskModelList!.add(new TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.newTaskModelList != null) {
      data['data'] = this.newTaskModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

