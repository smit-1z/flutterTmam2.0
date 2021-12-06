import 'package:authentification/Controllers/firestore_controller.dart';
import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/utils/constants.dart';
import 'package:authentification/utils/my_print.dart';
import 'package:authentification/utils/shared_pref_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;


class UserController {

  Future<bool> isUserExist(BuildContext context, String uid) async {
    if (uid == null || uid.isEmpty) return false;

    DocumentSnapshot<
        Map<String, dynamic>> documentSnapshot = await FirestoreController()
        .firestore.collection(USERS_COLLECTION).doc(uid)
        .get();
    if (documentSnapshot.exists) {
      UserProvider userProvider = Provider.of<UserProvider>(
          context, listen: false);
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data != null && data.isNotEmpty) {
        if (userProvider.userModel == null)
          userProvider.userModel = UserModel.fromMap(data);
        else{

        }
          // userProvider.userModel?.updateFromMap(data);
        //await SembastManager().set(SEMBAST_USERDATA, userProvider.userModel!.sembastToMap());
        //await SembastManager().set(SEMBAST_USERID, userProvider.userModel!.id);
      }
    }

    return documentSnapshot.exists;
  }

  Future<void> createNewUser(BuildContext context, {String? loginType}) async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      User user = userProvider.firebaseUser!;

      if(loginType == null || loginType.isEmpty) {
        loginType = user.email != null && user.email!.isNotEmpty
            ? (user.displayName != null && user.displayName!.isNotEmpty ? LOGIN_TYPE_GOOGLE : LOGIN_TYPE_EMAIL):LOGIN_TYPE_EMAIL;

      }

      if(user != null) {
        UserModel userModel = UserModel(
          id: user.uid,
          name: user.displayName,
          email: user.email

        );

        Map<String, dynamic> data = userModel.toMap();
        data["createdtime"] = FieldValue.serverTimestamp();

        WriteBatch batch = FirestoreController().firestore.batch();

        batch.set(FirestoreController().firestore.collection(USERS_COLLECTION).doc(user.uid), data);
        await batch.commit().whenComplete(() async {
          FirestoreController().firestore.collection(USERS_COLLECTION).doc(user.uid).get().then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
            UserModel userModel = UserModel.fromMap(documentSnapshot.data() ?? {});
          userProvider.userModel = userModel;
          });
        });

        //MyPrint.logOnConsole("User:${userProvider.userModel}");

        MyPrint.printOnConsole("Create User Completed");
      }
    }
    catch(e) {
      MyPrint.printOnConsole("Error in UserController().createUser():${e}");
    }
  }

  Future<void> updateUser(BuildContext context,UserModel userModel) async {
    try {


      // if(user != null) {
      //   UserModel userModel = UserModel(
      //       id: user.uid,
      //       name: user.displayName,
      //       email: user.email
      //
      //   );

        Map<String, dynamic> data = userModel.toMap();
        data["createdTime"] = FieldValue.serverTimestamp();


      await FirestoreController().firestore.collection(USERS_COLLECTION).doc(userModel.id).update(userModel.toMap());

        //MyPrint.logOnConsole("User:${userProvider.userModel}");

        MyPrint.printOnConsole("update user ");
      }
    // }
    catch(e) {
      MyPrint.printOnConsole("Error in UserController().createUser():${e}");
    }
  }

  Future<UserModel?> getUserList(context) async {
    // var venueData = await FirestoreController()
    //     .firestore
    //     .collection(VENUES_COLLECTION)
    //     .get();
    // return venueData;
    UserModel? userData  = UserModel();
    SharedPrefManager prefManager = SharedPrefManager();
    String? userid = await prefManager.getString(USERID);

    UserProvider userProvider  = Provider.of<UserProvider>(context,listen: false);
    print("User id : $userid");
    // DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection("users").doc(userid).get();
    // Map<String, dynamic>? data = documentSnapshot.data();
    // print(data);
    // if(data != null){
    //   userData = UserModel.fromMap(data);
    //   print( userData);
    //
    // } else {
    //   userData = null;
    // }
    Query<Map<String, dynamic>> query = FirestoreController().firestore.collection(USERS_COLLECTION).where("id",isEqualTo:userid );
// DocumentSnapshot<Map<String, dynamic>> doc  =query.get();
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get().catchError((error) {
      print(error);
    } );
    MyPrint.printOnConsole("Snapshots:${querySnapshot.docs}");

    if(querySnapshot.docs.length != 0){

      UserModel userModel = UserModel.fromMap(querySnapshot.docs.first.data());
      userData = userModel;
      // print(userModel);
      userProvider.userModel = userModel;
      // userProvider.serchedUserModel =  UserModel.fromMap(querySnapshot.docs.first.data());
    } else {
      userData = null;
    }

    // data.docs.forEach((e) {
    //   userData = ();
    // });
    // print(userData!.toMap());

    return userData;
  }

  //To Get UserData and store it in UserProvider
  // Future<void>? getUserData(BuildContext context, String uid) async {
  //   DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirestoreController().firestore.collection(USERS_COLLECTION).doc(uid).get();
  //   if(documentSnapshot.exists) {
  //     UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  //     Map<String, dynamic>? data = documentSnapshot.data();
  //     if(data != null && data.isNotEmpty) {
  //       if(userProvider.userModel == null) userProvider.userModel = UserModel.fromMap(data);
  //       else userProvider.userModel?.updateFromMap(data);
  //       userProvider.notifyListeners();
  //     }
  //   }
  // }



}
