import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/database_helper.dart';
import 'package:flutter_application_1/data/task_data.dart';

class AddTodo extends StatelessWidget {
  AddTodo(
      {Key? key,
      required this.title,
      required this.icons,
      required this.btn,
      required this.task})
      : super(key: key);
  Task task;
  var textController = TextEditingController();
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  String title;
  String btn;
  bool icons;

  @override
  Widget build(BuildContext context) {
    if (task.todo != null) {
      textController.text = task.todo;
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
          ],
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                alignment: const Alignment(0, -0.25),
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: textController,
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: title,
                      hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (textController.text.trim() != '') {
              _insert();
            }
            Navigator.pop(context, true);
          },
          label: Text(btn),
          icon: Icon(icons ? Icons.add : Icons.edit),
        ));
  }

  _insert() async {
    task.todo = textController.text;
    DataBaseHelper dataBaseHelper = DataBaseHelper();
    if (task.id == null) {
      await dataBaseHelper.insert(task);
    } else {
      await dataBaseHelper.update(task);
    }
  }
}
