import 'package:dynamic_theme_app/models/task.dart';
import 'package:dynamic_theme_app/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import './themes.dart';
import './add_task_page.dart';
import './widgets/button.dart';
import './widgets/task_tile.dart';
import '../helpers/notify_helper.dart';
import '../providers/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  NotifyHelper? notifyHelper;
  late Future<List<Task>> _tasksFuture;
  // bool isInit = true;
  //
  // Future<List<Task>> _obtainTasksFuture() {
  //   return Provider.of<TaskProvider>(context).getTasks();
  // }

  @override
  void initState() {
    // TODO: implement initState
    notifyHelper = NotifyHelper(context);
    notifyHelper!.initializeNotification();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // notifyHelper = NotifyHelper(context);
    // notifyHelper!.initializeNotification();
    _tasksFuture = Provider.of<TaskProvider>(context).getTasks();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 12),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return FutureBuilder<List<Task>>(
      future: _tasksFuture,
      builder: (ctx, snapShot) {
        if (snapShot.data == null) {
          return const Expanded(
            child: Center(
              child: Text('Add Tasks!'),
            ),
          );
        } else {
          return Expanded(
            child: ListView.builder(
              itemCount: snapShot.data!.length,
              itemBuilder: (ctx, index) {
                Task task = snapShot.data![index];
                if (task.repeat == 'Daily') {
                  // DateTime date =
                  //     DateFormat.jm().parse(task.startTime.toString());
                  // var myTime = DateFormat('HH:MM').format(date);
                  // notifyHelper!.scheduledNotification(
                  //     int.parse(myTime.split(':')[0]),
                  //     int.parse(myTime.split(':')[1]),
                  //     task);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                  context,
                                  task,
                                );
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (task.date ==
                    DateFormat.yMd().format(_selectedDate)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showBottomSheet(
                                  context,
                                  task,
                                );
                              },
                              child: TaskTile(task),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
      },
    );
  }

  // const Expanded(
  // child: Center(
  // child: Text('Add Tasks!'),
  // ),
  // )

  // Consumer<TaskProvider>(
  // child: const Expanded(
  // child: Center(
  // child: Text('Add Tasks!'),
  // ),
  // ),
  // builder: (ctx, taskProvider, ch) => taskProvider.tasks.isEmpty
  // ? ch!
  //     : Expanded(
  // child: ListView.builder(
  // itemCount: taskProvider.tasks.length,
  // itemBuilder: (ctx, index) {
  // Task task = taskProvider.tasks[index];
  // if (task.repeat == 'Daily') {
  // // DateTime date =
  // //     DateFormat.jm().parse(task.startTime.toString());
  // // var myTime = DateFormat('HH:MM').format(date);
  // // notifyHelper!.scheduledNotification(
  // //     int.parse(myTime.split(':')[0]),
  // //     int.parse(myTime.split(':')[1]),
  // //     task);
  // return AnimationConfiguration.staggeredList(
  // position: index,
  // child: SlideAnimation(
  // child: FadeInAnimation(
  // child: Row(
  // children: [
  // GestureDetector(
  // onTap: () {
  // _showBottomSheet(
  // context,
  // task,
  // );
  // },
  // child: TaskTile(task),
  // )
  // ],
  // ),
  // ),
  // ),
  // );
  // } else if (task.date ==
  // DateFormat.yMd().format(_selectedDate)) {
  // return AnimationConfiguration.staggeredList(
  // position: index,
  // child: SlideAnimation(
  // child: FadeInAnimation(
  // child: Row(
  // children: [
  // GestureDetector(
  // onTap: () {
  // _showBottomSheet(
  // context,
  // task,
  // );
  // },
  // child: TaskTile(task),
  // )
  // ],
  // ),
  // ),
  // ),
  // );
  // } else {
  // return Container();
  // }
  // },
  // ),
  // ),
  // )

  _showBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.27
            : MediaQuery.of(context).size.height * 0.36,
        color: Provider.of<ThemeProvider>(context, listen: false).isLightMode
            ? Colors.white
            : darkGreyClr,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Provider.of<ThemeProvider>(context, listen: false)
                        .isLightMode
                    ? Colors.grey[300]
                    : Colors.grey[600],
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: 'Task Completed',
                    onTap: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .taskIsCompleted(task.id!);
                      Navigator.of(context).pop();
                    },
                    color: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              label: 'Delete Task',
              onTap: () {
                Provider.of<TaskProvider>(context, listen: false)
                    .removeTask(task);
                Navigator.of(context).pop();
              },
              color: Colors.red[500]!,
              context: context,
            ),
            const SizedBox(height: 20),
            _bottomSheetButton(
              label: 'Close',
              onTap: () {
                Navigator.of(context).pop();
              },
              color: Colors.red[500]!,
              context: context,
              isClose: true,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Color color,
    required Function() onTap,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Provider.of<ThemeProvider>(context, listen: false).isLightMode
                    ? Colors.grey[300]!
                    : Colors.grey[600]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        initialSelectedDate: DateTime.now(),
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle(context),
              ),
              Text(
                'Today',
                style: headingStyle,
              ),
            ],
          ),
          Button(
              label: '+ Add Task',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) {
                    return const AddTaskPage();
                  }),
                );
              }),
        ],
      ),
    );
  }

  _appBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          themeProvider.toggleThemeMode(themeProvider.isLightMode);
          notifyHelper!.displayNotification(
            title: 'Theme Changed',
            body: themeProvider.isLightMode
                ? "Activated Dark Theme"
                : "Activated Light Theme",
          );
          //notifyHelper.scheduledNotification();
        },
        child: themeProvider.isLightMode
            ? const Icon(
                Icons.nightlight_round,
                size: 20,
                color: Colors.black87,
              )
            : const Icon(
                Icons.wb_sunny_rounded,
                size: 20,
              ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage(
            'images/profile.png',
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }
}
