import 'package:authentification/Controllers/firestore_controller.dart';
import 'package:authentification/Controllers/user_controller.dart';
import 'package:authentification/create_task.dart';
import 'package:authentification/models/task_model.dart';
import 'package:authentification/models/user_model.dart';
import 'package:authentification/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
      ),
      home: MyApp1(),
    ));

class MyApp1 extends StatefulWidget {
  final String? value;

  MyApp1({Key? key, this.value}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  List todos = [];

  bool isloggedin = true;
  UserModel? userModelList;

  bool isLoading = false;

  Future getTodoList() async {
    setState(() {
      isLoading = true;
    });
    UserController userController = UserController();
    userModelList = await userController.getUserList(context);

    // print(userModelList!.toMap());

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    todos.add("item!");
    todos.add("item2");
    todos.add("item3");
    todos.add("item4");

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getTodoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () async {
            bool isTrue = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
            print(isTrue);
            if (isTrue) {
              getTodoList();
            }
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Todo"),
        ),
        body: userModelList == null
            ? Container(
                child: Center(
                  child: Text("No Todos"),
                ),
              )
            : todoView());
  }

  Widget todoView() {
    return userModelList!.taskList!.length == 0
        ? Center(
            child: Container(
            child: Text("No Todos"),
          ))
        : todoListView();
  }

  Widget todoListView() {
    return ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: userModelList!.taskList!.length,
        itemBuilder: (BuildContext context, int index) {
          return todoItemView(userModelList!.taskList![index], userModelList!);
        });
  }

  GlobalKey key = GlobalKey();

  Widget todoItemView(TaskModels taskModels, UserModel userModel) {
    return Slidable(
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
        closeThreshold: 0.9,

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () async {
          bool? isTrue = await showDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text("Delete"),
                  content: Text("Are you sure you want to delete?"),
                  actions: [
                    CupertinoButton(
                        child: Text("No"),
                        onPressed: () => Navigator.pop(context, false)),
                    CupertinoButton(
                        child: Text("Yes"),
                        onPressed: () => Navigator.pop(context, true))
                  ],
                );
              });
          if (isTrue == true) {
            await FirestoreController()
                .firestore
                .collection(USERS_COLLECTION)
                .doc(userModel.id)
                .update({
              "tasks": FieldValue.arrayRemove([taskModels.toMap()])
            });
            userModelList!.taskList!.remove(taskModels);

            setState(() {});
          }
        }),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (BuildContext? context) async {
              bool? isTrue = await showDialog(
                  context: context!,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("Delete"),
                      content: Text("Are you sure you want to delete?"),
                      actions: [
                        CupertinoButton(
                            child: Text("No"),
                            onPressed: () => Navigator.pop(context, false)),
                        CupertinoButton(
                            child: Text("Yes"),
                            onPressed: () => Navigator.pop(context, true))
                      ],
                    );
                  });
              if (isTrue == true) {
                await FirestoreController()
                    .firestore
                    .collection(USERS_COLLECTION)
                    .doc(userModel.id)
                    .update({
                  "tasks": FieldValue.arrayRemove([taskModels.toMap()])
                });
                userModelList!.taskList!.remove(taskModels);

                setState(() {});
              }
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      // closeOnScroll: false,

      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () async {
          // Navigator.pop(context);
        }),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            autoClose: false,
            onPressed: (BuildContext? context) async {
              TextEditingController controller = TextEditingController();
              controller.text = taskModels.task!;
              String value = await showDialog(
                // isScrollControlled: true,
                context: context!,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: Text("Edit tasks"),
                    actions: [
                      CupertinoButton(child: Text("Cancel"), onPressed: () {}),
                      CupertinoButton(child: Text("Confirm"), onPressed: () async {
                        await FirestoreController()
                            .firestore
                            .collection(USERS_COLLECTION)
                            .doc(userModel.id)
                            .update({
                          "tasks": FieldValue.arrayRemove([taskModels.toMap()])
                        });
                        taskModels.task = controller.text;

                        setState(() {

                        });
                        Navigator.pop(context,controller.text);
                        FocusScope.of(context).requestFocus(new FocusNode());

                      })
                    ],
                    content: Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Text("Are you sure you want to edit this task ?"),
                          TextFormField(
                            controller: controller,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              if(value != null){

                await FirestoreController()
                    .firestore
                    .collection(USERS_COLLECTION)
                    .doc(userModel.id)
                    .update({
                  "tasks": FieldValue.arrayUnion([taskModels.toMap()])
                });
              }
            },
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
        ],
      ),

      // Specify a key if the Slidable is dismissible.

      key: const ValueKey(0),

      child: Container(
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "${taskModels.priority ?? ""}  ${taskModels.task ?? ""} ${taskModels.date ?? ""} ${taskModels.time ?? ""} ",
                  style: TextStyle(color: Colors.black),
                )),
                InkWell(
                    onTap: () async {
                      bool? isTrue = await showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("Delete"),
                              content: Text("Are you sure you want to delete?"),
                              actions: [
                                CupertinoButton(
                                    child: Text("No"),
                                    onPressed: () =>
                                        Navigator.pop(context, false)),
                                CupertinoButton(
                                    child: Text("Yes"),
                                    onPressed: () =>
                                        Navigator.pop(context, true))
                              ],
                            );
                          });
                      if (isTrue == true) {
                        await FirestoreController()
                            .firestore
                            .collection(USERS_COLLECTION)
                            .doc(userModel.id)
                            .update({
                          "tasks": FieldValue.arrayRemove([taskModels.toMap()])
                        });
                        userModelList!.taskList!.remove(taskModels);

                        setState(() {});
                      }
                    },
                    child: Icon(Icons.delete))
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
  createTodos() {
    DocumentReference documentReference =
    Firestore.instance.collection("MyTodos").document(todoTitle);

    //Map
    Map<String, String> todos = {"todoTitle": todoTitle};

    documentReference.setData(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
    Firestore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("$item deleted");
    });
  }

 */
  @override
  Widget build2(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todos"),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  child: ListTile(
                    title: Text(todos[index]),
                  ),
                ));
          }),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Todolist"),
                  content: TextField(
                    onChanged: (String value) {
                      todoTitle = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          createTodos();

                          Navigator.of(context).pop();
                        },
                        child: Text("Add"))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                    snapshots.data.documents[index];
                    return Dismissible(
                        onDismissed: (direction) {
                          deleteTodos(documentSnapshot["todoTitle"]);
                        },
                        key: Key(documentSnapshot["todoTitle"]),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title: Text(documentSnapshot["todoTitle"]),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteTodos(documentSnapshot["todoTitle"]);
                                }),
                          ),
                        ));
                  });
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );


  }

 */
}
