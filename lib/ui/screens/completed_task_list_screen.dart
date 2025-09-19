/*
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/completed_task_list_model.dart';
import 'package:task_manager_firebase_09_09_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/task_item.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: CompletedTaskListScreen()));

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTaskListInProgress = false;
  CompletedTaskListByStatusModel? completedTaskListByStatusModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_completedNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBackground(
        child: Column(
          children: [
            SizedBox(height: 8),
            */
/*Expanded(
              child:
              _getCompletedTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: completedTaskListByStatusModel?.completedTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: completedTaskListByStatusModel!
                        .completedTaskModelList![index],
                    refreshList: () {
                      _completedNewTaskList();
                      setState(() {});
                    },);
                },
              ),
            ),*//*

          ],
        ),
      ),
    );
  }


*/
/* Future<void> _completedNewTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.completedTaskListByStatus('Completed'));

    if (response.isSuccess) {
      completedTaskListByStatusModel =
          CompletedTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getCompletedTaskListInProgress = false;
    setState(() {});
  }


}*//*


}*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/task_item.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TaskModel> completedTasks = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTasks();
  }

  Future<void> _getCompletedTasks() async {
    _firestore
        .collection('tasks')
        .where('status', isEqualTo: 'Completed')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        completedTasks = snapshot.docs
            .map((doc) => TaskModel.fromFirestore(doc))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBackground(
        child: ListView.builder(
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            return TaskItem(
              taskModel: completedTasks[index],
              refreshList: _getCompletedTasks,
            );
          },
        ),
      ),
    );
  }
}