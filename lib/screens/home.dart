import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/add_todo.dart';
import 'package:flutter_application_1/database/database_helper.dart';
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

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.black),
        backgroundColor: Colors.black,
        title: const Text(
          'ToDos',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        color: Colors.black,
        child: populateListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task task;
          updateNav(
              title: 'Add New Todo',
              btn: 'Add',
              task: task = Task.withTodo(isDone: false));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
    );
  }

  updateListView() async {
    todoList = await dataBaseHelper.listOfTodoClass();
    setState(() {
      todoList = todoList;
      count = todoList.length;
    });
  }

  populateListView() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
          reverse: true,
          shrinkWrap: true,
          itemCount: count,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(motion: StretchMotion(), children: [
                SlidableAction(
                  onPressed: (context) async {
                    await dataBaseHelper.delete(todoList[index]);
                    await updateListView();
                  },
                  icon: Icons.delete,
                  backgroundColor: Colors.red.shade300,
                )
              ]),
              child: Card(
                color: todoList[index].isDone
                    ? Colors.lightGreenAccent
                    : Colors.white,
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
                      decoration: todoList[index].isDone
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  // trailing: todoList[index].isDone?IconButton(
                  //   onPressed: () async {
                  //     await dataBaseHelper.delete(todoList[index]);
                  //     await updateListView();
                  //   },
                  //   icon: const Icon(Icons.delete),
                  // ):null,
                  onLongPress: () {
                    updateNav(
                        title: 'Update Todo',
                        btn: 'update',
                        task: todoList[index]);
                  },
                ),
              ),
            );
          }),
    );
  }

  void updateNav(
      {required String title, required String btn, required Task task}) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddTodo(title: title, btn: btn, task: task);
    }));
    updateListView();
  }

  void _isDone({required Task done}) async {
    await dataBaseHelper.update(done);
    updateListView();
  }
}
