import 'package:flutter/material.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/cancelled_task_list_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/completed_task_list_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/new_task_list_screen.dart';
import 'package:task_manager_firebase_09_09_25/ui/screens/progress_task_list_screen.dart';


void main() => runApp(MaterialApp(home: MainBottomNavScreen()));

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  static const String name='/home';
  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {

 int _selectedIndex=0;
final List<Widget> _screens=[
  NewTaskListScreen(),
  ProgressTaskListScreen(),
  CompletedTaskListScreen(),
  CancelledTaskListScreen(),

 ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
          onDestinationSelected: (int index){
          _selectedIndex=index;
          setState(() {

          });
          },
          destinations: [
            NavigationDestination(icon: Icon(Icons.new_label_outlined), label: 'New'),
            NavigationDestination(icon: Icon(Icons.refresh), label: 'Progress'),
            NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
            NavigationDestination(icon: Icon(Icons.cancel_outlined), label: 'Canceled')
          ]),
    );
  }
}
