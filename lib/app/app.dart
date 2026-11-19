import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../features/tasks/data/task_repository.dart';
import '../features/tasks/presentation/tasks_view_model.dart';
import 'router.dart';

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(create: (_) => LocalTaskRepository()),
        ChangeNotifierProvider<TasksViewModel>(
          create: (context) =>
              TasksViewModel(repository: context.read<TaskRepository>()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        routerConfig: appRouter,
      ),
    );
  }
}
