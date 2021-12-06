import 'package:authentification/Controllers/providers/connection_provider.dart';
import 'package:authentification/Controllers/providers/user_provider.dart';
import 'package:authentification/utils/my_print.dart';
import 'package:authentification/utils/snakbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthenticationController {
  Future<bool> isUserLogin({bool initializeUserid = false, required BuildContext context}) async {
    ConnectionProvider connectionProvider = Provider.of(context, listen: false);
    if(!connectionProvider.isInternet) {
      Snakbar().show_error_snakbar(context, "No Internet");
      return false;
    }

    User? user = FirebaseAuth.instance.currentUser;
    bool isLogin = user != null;
    if(isLogin && initializeUserid && context != null) {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.userid = user.uid;
      //userProvider.userid = "u3V5Iv9svVRBpAlCDSAedHPRQ683";
      userProvider.firebaseUser = user;
      // await SharedPrefManager().setString(SEMBAST_USERID, userProvider.userid!);
      // await SembastManager().set(SEMBAST_USERID, userProvider.userid!);
    }
    MyPrint.printOnConsole("Login:${isLogin}");
    return isLogin;
  }

  //If user not exist then will create new user
  Future<User?> signInWithEmailAndPassword(BuildContext context,
      {required String email, required String password}) async {
    ConnectionProvider connectionProvider = Provider.of(context, listen: false);
    if (!connectionProvider.isInternet) {
      Snakbar().show_error_snakbar(context, "No Internet");
      return null;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          return userCredential.user;
        }
        else {
          await userCredential.user!.delete();
          UserCredential newUserCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          await newUserCredential.user!.sendEmailVerification();
          if (newUserCredential.user != null) {
            await newUserCredential.user!.sendEmailVerification();
          }

          return newUserCredential.user;
        }
      }

      return userCredential.user!;
    }
    on FirebaseAuthException catch (e) {
      String message = "";

      MyPrint.printOnConsole("Code:${e.code}");
      switch (e.code) {
        case "invalid-email" :
          {
            MyPrint.printOnConsole("Message:${"message_email_invalid"}");
            Snakbar().show_error_snakbar(context, "message_email_invalid");
          }
          break;

        case "user-disabled" :
          {
            MyPrint.printOnConsole("Message:${"message_email_Disabled"}");
            Snakbar().show_info_snakbar(context, "message_email_Disabled");
          }
          break;

        case "user-not-found" :
          {
            message = "Entered Email doesn't exist";
            try {
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                  email: email, password: password);
              if (userCredential.user != null &&
                  !userCredential.user!.emailVerified) {
                await userCredential.user!.sendEmailVerification();
              }

              return userCredential.user;
            }
            on FirebaseAuthException catch (e) {
              MyPrint.printOnConsole("Code:${e.code}");
              MyPrint.printOnConsole(
                  "Error in Create User with Email and Password:${e.message}");
            }
          }
          break;

        case "wrong-password" :
          {
            MyPrint.printOnConsole(
                "Message:${"message_email_passwodnotvalid"}");
            Snakbar().show_error_snakbar(
                context, "message_email_passwodnotvalid");
          }
          break;

        default :
          {
            MyPrint.printOnConsole("Message:${"message_email_ath"}");
            Snakbar().show_error_snakbar(context, "message_email_ath");
          }
      }
    }

    return null;
  }

  //Will Sing in with google
  //If Sign in success, will return User Object else return null
  Future<User?> signInWithGoogle(BuildContext context) async {
    ConnectionProvider connectionProvider = Provider.of(context, listen: false);
    if (!connectionProvider.isInternet) {
      Snakbar().show_error_snakbar(context, "No Internet");
      return null;
    }

    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn()
        .signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);

        return userCredential.user!;
      }
      on FirebaseAuthException catch (e) {
        String message = "";

        MyPrint.printOnConsole("Code:${e.code}");
        switch (e.code) {
          case "account-exists-with-different-credential" :
            {
              List<String> methods = await FirebaseAuth.instance
                  .fetchSignInMethodsForEmail(e.email!);
              MyPrint.printOnConsole("Methods:${methods}");

              Snakbar().show_info_snakbar(context, "email_already_exist");
            }
            break;

          case "invalid-credential" :
            {
              message = "Credential is Invalid";
              MyPrint.printOnConsole("Message:${"email_credential_invalid"}");
              Snakbar().show_error_snakbar(context, "email_credential_invalid");
              //MyToast.showError(message, context);
            }
            break;

          case "operation-not-allowed" :
            {
              MyPrint.printOnConsole("Message:${"email_operation_notallowd"}");
              Snakbar().show_error_snakbar(
                  context, "email_operation_notallowd");
              // MyToast.showError(message, context);
            }
            break;

          case "user-disabled" :
            {
              MyPrint.printOnConsole("Message:${"user_disable_message"}");
              Snakbar().show_info_snakbar(context, "user_disable_message");
            }
            break;

          case "user-not-found" :
            {
              MyPrint.printOnConsole("Message:${"user_notfound_message"}");
              Snakbar().show_info_snakbar(context, "user_notfound_message");
            }
            break;

          case "wrong-password" :
            {
              MyPrint.printOnConsole("Message:${"user_passwordwrong_message"}");
              Snakbar().show_error_snakbar(
                  context, "user_passwordwrong_message");
              //MyToast.showError(message, context);
            }
            break;

          default :
            {
              message = "Error in Authentication";
              MyPrint.printOnConsole("Message:${e.message}");
              Snakbar().show_error_snakbar(context, "user_autherror_message");
              // MyToast.showError(message, context);
            }
        }
      }

      return null;
    }
  }
}