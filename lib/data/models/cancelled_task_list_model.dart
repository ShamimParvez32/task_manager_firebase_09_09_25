import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';

class CancelledTaskListByStatusModel {
  String? status;
  List<TaskModel>? cancelledTaskModelList;

  CancelledTaskListByStatusModel({this.status, this.cancelledTaskModelList});

  CancelledTaskListByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      cancelledTaskModelList = <TaskModel>[];
      json['data'].forEach((v) {
        cancelledTaskModelList!.add(new TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cancelledTaskModelList != null) {
      data['data'] = this.cancelledTaskModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

