import 'dart:developer';

class MyPrint {
  static void printOnConsole(Object s) {
    print(s);
  }

  static void logOnConsole(Object s) {
    log(s.toString());
  }
}