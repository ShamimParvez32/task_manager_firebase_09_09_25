/*

import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/cancelled_task_list_model.dart';
import 'package:task_manager_firebase_09_09_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/task_item.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: CancelledTaskListScreen()));

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {

  bool _getCancelledTaskListInProgress = false;
  CancelledTaskListByStatusModel? cancelledTaskListByStatusModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_cancelledNewTaskList();
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
            Expanded(
              child:
              _getCancelledTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: cancelledTaskListByStatusModel
                    ?.cancelledTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  //return //TaskItem(
                  //taskModel: cancelledTaskListByStatusModel!
                  // .cancelledTaskModelList![index],
                  //refreshList: () {
                  // _cancelledNewTaskList();
                  //setState(() {});
                  //}, task: null,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


*/
/*

Future<void> _cancelledNewTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.cancelledTaskListByStatus('Cancelled'));

    if (response.isSuccess) {
      cancelledTaskListByStatusModel =
          CancelledTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getCancelledTaskListInProgress = false;
    setState(() {});
  }


}
*//*

}

*/
/*

import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/progress_task_List_model.dart';
import 'package:task_manager_firebase_09_09_25/data/models/task_list_By_Status_model.dart';
import 'package:task_manager_firebase_09_09_25/data/services/network_caller.dart';
import 'package:task_manager_firebase_09_09_25/data/utlis/urls.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/show_snakebar_message.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/task_item.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

void main() => runApp(MaterialApp(home: ProgressTaskListScreen()));

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _getProgressTaskListInProgress = false;
  ProgressTaskListByStatusModel? progressTaskListByStatusModel;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_progressNewTaskList();
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
            Expanded(
              child:
              _getProgressTaskListInProgress
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: progressTaskListByStatusModel?.progressTaskModelList?.length ??
                    0,
                itemBuilder: (context, index) {
                  return TaskItem(
                    taskModel: progressTaskListByStatusModel!
                        .progressTaskModelList![index],
                    refreshList: () {
                      //_progressNewTaskList();
                      setState(() {});
                    },);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }






Future<void> _progressNewTaskList() async {
    _getProgressTaskListInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.progressTaskListByStatus('Progress'));

    if (response.isSuccess) {
      progressTaskListByStatusModel =
          ProgressTaskListByStatusModel.fromJson(response.responseBody!);
    }
    else {
      showSnakeBarMessage(context, response.errorMessage);
    }
    _getProgressTaskListInProgress = false;
    setState(() {});
  }



}

*/



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/data/models/taskModel.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/screen_background.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/task_item.dart';
import 'package:task_manager_firebase_09_09_25/ui/widgets/tm_app_bar.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() => _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<TaskModel> cancelledTasks = [];

  @override
  void initState() {
    super.initState();
    _getCancelledTasks();
  }

  Future<void> _getCancelledTasks() async {
    _firestore
        .collection('tasks')
        .where('status', isEqualTo: 'Cancelled')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        cancelledTasks = snapshot.docs
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
          itemCount: cancelledTasks.length,
          itemBuilder: (context, index) {
            return TaskItem(
              taskModel: cancelledTasks[index],
              refreshList: _getCancelledTasks,
            );
          },
        ),
      ),
    );
  }
}