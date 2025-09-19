import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';

class ProgressTaskListByStatusModel {
  String? status;
  List<TaskModel>? progressTaskModelList;

  ProgressTaskListByStatusModel({this.status, this.progressTaskModelList});

  ProgressTaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      progressTaskModelList = <TaskModel>[];
      json['data'].forEach((v) {
        progressTaskModelList!.add(new TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.progressTaskModelList != null) {
      data['data'] = this.progressTaskModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

