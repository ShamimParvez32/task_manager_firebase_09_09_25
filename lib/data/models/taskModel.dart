/*
class TaskModel {
  String? sId;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  TaskModel({this.sId, this.title, this.description, this.status, this.createdDate});

  TaskModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
*/


import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? title;
  String? description;
  String? status;
  String? createdDate;
  String? userId; // Add user ID for multi-user support

  TaskModel({
    this.id,
    this.title,
    this.description,
    this.status,
    this.createdDate,
    this.userId,
  });

  // Convert Firestore Document to TaskModel
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle Timestamp to String conversion for createdDate
    String formattedDate;
    if (data['createdDate'] is Timestamp) {
      Timestamp timestamp = data['createdDate'] as Timestamp;
      formattedDate = timestamp.toDate().toString();
    } else {
      formattedDate = data['createdDate']?.toString() ?? '';
    }

    return TaskModel(
      id: doc.id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      status: data['status']?.toString() ?? 'New',
      createdDate: formattedDate,
      userId: data['userId']?.toString(),
    );
  }

  // Convert TaskModel to Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdDate != null) 'createdDate': createdDate,
      if (userId != null) 'userId': userId,
    };
  }

  // Keep existing fromJson and toJson for compatibility
  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdDate = json['createdDate'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['createdDate'] = this.createdDate;
    data['userId'] = this.userId;
    return data;
  }
}