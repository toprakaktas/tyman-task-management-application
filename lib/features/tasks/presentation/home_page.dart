import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tyman/core/widgets/app_bottom_nav_bar.dart';
import 'package:tyman/data/models/app_user.dart';
import 'package:tyman/data/services/auth_service.dart';
import 'package:tyman/data/services/user_service.dart';
import 'package:tyman/domain/usecases/auth/sign_out.dart';
import 'package:tyman/domain/usecases/task/add_task.dart';
import 'package:tyman/domain/usecases/task/fetch_task_counts_for_categories.dart';
import 'package:tyman/domain/usecases/user/fetch_user_profile.dart';
import 'package:tyman/domain/usecases/user/update_profile.dart';
import 'package:tyman/domain/usecases/user/upload_profile_image.dart';
import 'package:tyman/features/tasks/presentation/widgets/add_task_dialog.dart';
import 'package:tyman/features/tasks/presentation/widgets/home_app_bar.dart';
import 'package:tyman/features/tasks/presentation/widgets/task_grid.dart';
import 'package:tyman/features/profile/presentation/my_page.dart';
import 'package:tyman/data/models/task_model.dart';
import 'package:tyman/features/tasks/presentation/widgets/upcoming_tasks_card.dart';

class HomePage extends StatefulWidget {
  final FetchTaskCountsForCategories fetchTaskCounts;
  final AddTask addTask;
  final FetchUserProfile fetchUserProfile;

  const HomePage(
      {super.key,
      required this.fetchTaskCounts,
      required this.addTask,
      required this.fetchUserProfile});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<TaskModel>> taskCategories;
  AppUser? appUser;

  @override
  void initState() {
    super.initState();
    taskCategories = widget.fetchTaskCounts();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      appUser = await widget.fetchUserProfile(firebaseUser.uid);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _refreshData() async {
    if (mounted) {
      setState(() {
        taskCategories = widget.fetchTaskCounts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HomeAppBar(user: appUser),
      body: FutureBuilder<List<TaskModel>>(
        future: taskCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tasks found.'));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshData,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const UpcomingTasksCard(),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: const Text(
                      'Tasks',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: TaskGrid(taskCategories: snapshot.data!),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: AppBottomNavBar(
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MyPage(
                    uploadProfileImage: UploadProfileImage(UserService()),
                    signOut: SignOut(AuthService()),
                    fetchUserProfile: FetchUserProfile(UserService()),
                    updateProfile: UpdateProfile(UserService())),
              ));
            }
          }),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: buildFloatingButton(context),
    );
  }

  Widget buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.black,
      onPressed: () => showDialog(
          context: context,
          builder: (_) =>
              AddTaskDialog(onAdd: widget.addTask.call, onAdded: _refreshData)),
      child: const Icon(
        Icons.add,
        size: 35,
        color: Colors.white,
      ),
    );
  }
}
