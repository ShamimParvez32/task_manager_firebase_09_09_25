import 'package:task_manager_firebase_09_09_25/data/models/task_count_model.dart';

class CountTaskSummeryByStatusModel {
  String? status;
  List<TaskCountModel>? taskCountList;

  CountTaskSummeryByStatusModel({this.status, this.taskCountList});

  CountTaskSummeryByStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskCountList = <TaskCountModel>[];
      json['data'].forEach((v) {
        taskCountList!.add(new TaskCountModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.taskCountList != null) {
      data['data'] = this.taskCountList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


