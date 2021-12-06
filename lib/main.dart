import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/Login.dart';
import 'package:authentification/SignUp.dart';
import 'package:authentification/Start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Controllers/providers/connection_provider.dart';
import 'HomePage.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   runApp(MyApp());
   }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectionProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  //
  // Future<void> requestPermission(Permission permission, BuildContext context) async {
  //   final status = await permission.request();
  //
  //   if (!(status == PermissionStatus.granted)) {
  //     Snakbar().show_info_snakbar(context,Messages.storage_permission);
  //   }
  // }
  //
  // Future<void> handlePermissions(BuildContext context) async {
  //   await requestPermission(Permission.manageExternalStorage, context);
  //   //await requestPermission(Permission.location, context);
  // }

  @override
  Widget build(BuildContext context) {
    //handlePermissions(context);

    return MaterialApp(

      theme: ThemeData(
          primaryColor: Colors.orange
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: <String,WidgetBuilder>{

        "Login" : (BuildContext context)=>Login(),
        "SignUp":(BuildContext context)=>SignUp(),
        "start":(BuildContext context)=>Start(),
      },

    );
  }
}


