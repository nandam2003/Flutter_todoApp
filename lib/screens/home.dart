import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_todo.dart';
import 'package:flutter_application_1/services/database_helper.dart';
import 'package:flutter_application_1/data/task_data.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  var todoList;
  int count = 0;
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 2, 46, 69),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(_currentUser!.photoURL.toString()),
                    radius: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    _currentUser!.displayName.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _currentUser!.email.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
            customLisTile(context, 'Settings', Icons.settings, () {}),
            customLisTile(context, 'Delete All', Icons.delete_forever, () {
              dataBaseHelper.deleteAll();
              updateListView();
            }),
            customLisTile(context, 'SignOut', Icons.exit_to_app, () {
              FirebaseAuth.instance.signOut();
            }),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 2, 46, 69)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                color: Color.fromARGB(255, 2, 46, 69),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'TODAY\'S TASKS',
              style: TextStyle(
                color: Color.fromARGB(255, 141, 153, 159),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            populateListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateNav(
            title: 'Enter New Task',
            btn: 'New Task',
            task: Task.withTodo(isDone: false),
            icons: true,
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile customLisTile(
      BuildContext context, String text, IconData? icon, onclick) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 2, 46, 69),
        ),
      ),
      trailing: Icon(
        icon,
      ),
      onTap: () {
        onclick();
        Navigator.pop(context);
      },
    );
  }

  updateListView() async {
    todoList = await dataBaseHelper.listOfTodoClass();
    setState(() {
      todoList = todoList;
      count = todoList.length;
    });
  }

  Widget populateListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: count,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane:
                  ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  borderRadius: BorderRadius.circular(30),
                  onPressed: (context) async {
                    await dataBaseHelper.delete(todoList[index]);
                    await updateListView();
                  },
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade300,
                )
              ]),
              child: Container(
                height: 70,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    leading: IconButton(
                      onPressed: () {
                        todoList[index].isDone = !todoList[index].isDone;
                        _isDone(done: todoList[index]);
                      },
                      icon: todoList[index].isDone
                          ? const Icon(Icons.check_box)
                          : const Icon(Icons.check_box_outline_blank),
                    ),
                    title: Text(
                      todoList[index].todo,
                      style: TextStyle(
                        color:
                            todoList[index].isDone ? Colors.grey : Colors.black,
                        decoration: todoList[index].isDone
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    onLongPress: () {
                      updateNav(
                        title: 'Update Todo',
                        btn: 'Update',
                        task: todoList[index],
                        icons: false,
                      );
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }

  void updateNav(
      {required String title,
      required bool icons,
      required String btn,
      required Task task}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTodo(
        title: title,
        btn: btn,
        task: task,
        icons: icons,
      );
    }));
    updateListView();
  }

  void _isDone({required Task done}) async {
    await dataBaseHelper.update(done);
    updateListView();
  }
}
