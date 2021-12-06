import 'package:authentification/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier{
  User? firebaseUser;
  String? userid;
  UserModel? userModel = UserModel();
}