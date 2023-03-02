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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color.fromARGB(255, 2, 46, 69),
          ),
          onPressed: () {},
        ),
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
            Container(
              color: Colors.grey[200],
              child: populateListView(),
            ),
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
                color: Colors.white,
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
                      btn: 'Update',
                      task: todoList[index],
                      icons: false,
                    );
                  },
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
