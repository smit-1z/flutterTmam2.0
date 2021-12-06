import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/Controllers/user_controller.dart';
import 'package:authentification/main.dart';
import 'package:authentification/models/task_model.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/todo.dart';
import 'package:authentification/widget/modal_progress_hud.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'widget/button_widget.dart';
import 'widget/date_picker_widget.dart';
import 'widget/date_range_picker_widget.dart';
import 'widget/datetime_picker_widget.dart';
import 'widget/time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Date (Range) & Time';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late FlutterLocalNotificationsPlugin fltrNotification;
  @override
  void initState() {
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('logo');
    var initilizationsSettings =
    new InitializationSettings(android: androidInitilize);
    fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings);
  }

  Future _showNotification(TaskModels task) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Raj Patel",importance: Importance.max);
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails);
    print("hello there ${task.date} ${task.time}");
    var scheduledTime = DateTime.now().add(Duration(seconds : 5));
    fltrNotification.schedule(1, "${task.task}","Just keep going. You never know how far you can go",
        scheduledTime, generalNotificationDetails);
  }

  createAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Congratulations!!! You Have created a new task"),
        content: Text("Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going."),
        actions: <Widget>[
          MaterialButton(
              elevation: 5.0,
              child: Text('GOT IT!'),
              onPressed: (){
                Navigator.of(context).pop();
              }
          )
        ],
      );
    });
  }















  int index = 0;

  Characters task = Characters("");

  var myController = TextEditingController();

  DateTime? date;

  TimeOfDay? time;

  String sendingDate = "", sendingtime = "";

  String priority = "";

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: time ?? initialTime,
    );

    if (newTime == null) return;

    setState(() => time = newTime);
  }

  String getText() {
    if (date == null) {
      return 'Select Date';
    } else {
      sendingDate = DateFormat('MM/dd/yyyy').format(date!);
      setState(() {});
      return DateFormat('MM/dd/yyyy').format(date!);
      // return '${date.month}/${date.day}/${date.year}';
    }
  }

  String getText2() {
    if (time == null) {
      return 'Select Time';
    } else {
      final hours = time!.hour.toString().padLeft(2, '0');
      final minutes = time!.minute.toString().padLeft(2, '0');
      String t_time = '$hours:$minutes';
      print(t_time);
      sendingtime = "$hours:$minutes";
      setState(() {});
      return '$hours:$minutes';
    }
  }
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => ModalProgressHUD(
    inAsyncCall: isLoading,
    progressIndicator: CircularProgressIndicator(),
    child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          bottomNavigationBar: buildBottomBar(),
          body: mainBody(),
        ),
  );

  Widget mainBody() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonHeaderWidget(
              title: 'Date',
              text: getText(),
              onClicked: () => pickDate(context),
            ),
            const SizedBox(height: 24),
            ButtonHeaderWidget(
              title: 'Time',
              text: getText2(),
              onClicked: () => pickTime(context),
            ),
            const SizedBox(height: 24),
            Container(
              child: TextFormField(
                validator: (input) {
                  if (input!.isEmpty) return 'Enter task';
                },
                controller: myController,
                decoration: InputDecoration(
                  labelText: 'Enter Task',
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              'Select Priority of the Task',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30.0),
            CustomRadioButton(
              elevation: 0,
              absoluteZeroSpacing: true,
              unSelectedColor: Theme.of(context).canvasColor,
              buttonLables: [
                'high',
                'mid',
                'low',
              ],
              buttonValues: [
                "HIGH",
                "MID",
                "LOW",
              ],
              buttonTextStyle: ButtonTextStyle(
                  selectedColor: Colors.white,
                  unSelectedColor: Colors.black,
                  textStyle: TextStyle(fontSize: 16)),
              radioButtonValue: (dynamic value) {
                print(value);
                priority = value;
                setState(() {});
              },
              selectedColor: Theme.of(context).accentColor,
            ),
            SizedBox(height: 70.0),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print("$sendingDate  $sendingtime ");
                TaskModels tasksModel = TaskModels(
                    date: sendingDate,
                    priority: priority,
                    task: myController.text,
                    time: sendingtime);
                // data["createdtime"] = FieldValue.serverTimestamp();


                UserProvider userProvider  = Provider.of<UserProvider>(context,listen: false);
                UserModel userModel = userProvider.userModel!;
                userModel.taskList!.addAll([tasksModel]);

              print(userModel.toMap());
                UserController userController= UserController();
                //
               await userController.updateUser(context, userModel);

                // var route = new MaterialPageRoute(
                //     builder: (BuildContext context) =>
                //     new MyApp1(value: myController.text),
                // );
                // Navigator.of(context).push(route);
                setState(() {
                  isLoading = false;
                });

                _showNotification(tasksModel);
                await createAlertDialog(context);
                Navigator.pop(context,true);
              },
              child: Text('Add Task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          title: Text('Basic'),
        ),
        BottomNavigationBarItem(
          icon: Text('DatePicker', style: style),
          title: Text('Advanced'),
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }
}
