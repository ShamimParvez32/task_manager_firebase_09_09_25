/*
class TaskCountModel {
  String? sId;
  int? sum;

  TaskCountModel({this.sId, this.sum});

  TaskCountModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sum'] = this.sum;
    return data;
  }
}
*/

class TaskCountModel {
  String? status;
  int? count;

  TaskCountModel({this.status, this.count});

  // For Firebase aggregation results
  factory TaskCountModel.fromFirestore(Map<String, dynamic> data) {
    return TaskCountModel(
      status: data['status'],
      count: data['count'],
    );
  }

  // Keep existing for compatibility
  TaskCountModel.fromJson(Map<String, dynamic> json) {
    status = json['_id'];
    count = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.status;
    data['sum'] = this.count;
    return data;
  }
}