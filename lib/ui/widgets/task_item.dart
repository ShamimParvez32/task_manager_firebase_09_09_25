

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({super.key, required this.taskModel, required this.refreshList});

  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text(widget.taskModel.createdDate ?? ''),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  child: Text(
                    widget.taskModel.status ?? 'New',
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(widget.taskModel.status ?? 'New'),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {
                      _deleteTask(widget.taskModel.id!);
                    }, icon: Icon(Icons.delete_outline),color: Colors.red,),
                    IconButton(
                      onPressed: () {
                        _buildShowDialog(context, textTheme);
                      },
                      icon: Icon(Icons.update_outlined,color: Colors.greenAccent,)
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

   _buildShowDialog(BuildContext context, TextTheme textTheme) {
     showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Status', style: textTheme.titleLarge),
          content: Column(
            children: [
              Divider(),
              ListTile(

                title: Text('New', style: textTheme.titleSmall?.copyWith(color: Colors.blue,backgroundColor: Colors.blueGrey)),
                onTap: () {
                 _taskStatusUpdate('New');
                },
              ),
              Divider(),
              ListTile(
                title: Text('Progress', style: textTheme.titleSmall?.copyWith(color: Colors.yellow,backgroundColor: Colors.blueGrey)),
                onTap: () {
                  _taskStatusUpdate('Progress');
                },
              ),
              Divider(),
              ListTile(
                title: Text('Completed', style: textTheme.titleSmall?.copyWith(color: Colors.green,backgroundColor: Colors.blueGrey),),
                onTap: () {
                  _taskStatusUpdate('Completed');
                },
              ),
              Divider(),
              ListTile(
                title: Text('Cancelled', style: textTheme.titleSmall?.copyWith(color: Colors.red,backgroundColor: Colors.blueGrey)),
                onTap: () {
                 _taskStatusUpdate('Cancelled');

                },
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  // Inside _TaskItemState class, update the methods:

  Future<void> _deleteTask(String id) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(id).delete();
      showSnakeBarMessage(context, 'Delete Successful');
      widget.refreshList();
    } catch (e) {
      showSnakeBarMessage(context, 'Failed to delete task');
    }
  }

  Future<void> _taskStatusUpdate(String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskModel.id)
          .update({'status': newStatus});

      showSnakeBarMessage(context, 'Status Updated to $newStatus');
      widget.refreshList();
      Navigator.pop(context);
    } catch (e) {
      showSnakeBarMessage(context, 'Failed to update status');
    }
  }




/*Future<void> _deleteTask(String id)async{
   final NetworkResponse response =await NetworkCaller.getRequest(url: Urls.deleteTask(id));
   if(response.isSuccess){
     showSnakeBarMessage(context, 'Delete Successful');
     widget.refreshList();
     setState(() {
     });
   }
   else {
     showSnakeBarMessage(context, response.errorMessage);
   }

  }

Future<void>_taskStatusUpdate(String newStatus)async{
    final NetworkResponse response =await NetworkCaller.getRequest(url: Urls.taskStatusUpdate( widget.taskModel.id!, newStatus));
    if(response.isSuccess){
      showSnakeBarMessage(context, 'Status Updated to $newStatus');
      widget.refreshList.call();
      Navigator.pop(context);
    }
    else{showSnakeBarMessage(context, response.errorMessage);}
}*/




  Color _getStatusColor(String status) {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
