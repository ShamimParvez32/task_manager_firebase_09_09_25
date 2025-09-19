class Task {
  int? id;
  String? title;
  String? description;
  String? status;
  String? createdDate;

  Task({this.id, this.title, this.description, this.status, this.createdDate});

  // Map এ কনভার্ট (Insert/Update এর জন্য)
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Map থেকে Object এ কনভার্ট (Read এর জন্য)
  Task.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
    status = map['status'];
    createdDate = map['createdDate'];
  }
}
