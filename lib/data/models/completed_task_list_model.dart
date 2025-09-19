import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';

class CompletedTaskListByStatusModel {
  String? status;
  List<TaskModel>? completedTaskModelList;

  CompletedTaskListByStatusModel({this.status, this.completedTaskModelList});

  CompletedTaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      completedTaskModelList = <TaskModel>[];
      json['data'].forEach((v) {
        completedTaskModelList!.add(new TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.completedTaskModelList != null) {
      data['data'] = this.completedTaskModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

