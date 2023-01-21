import 'package:flutter/material.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/data/task_data.dart';

class AddTodo extends StatelessWidget {
   AddTodo({Key? key,required this.title,required this.btn,required this.task}) : super(key: key);
   Task task;
   var textController = TextEditingController();
   DataBaseHelper dataBaseHelper = DataBaseHelper();
   String title;
   String btn;

  @override
  Widget build(BuildContext context) {
    textController.text = task.todo;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter Task to Do',
              )
            ),
            ElevatedButton(
                  onPressed: () {
                    _insert();
                    Navigator.pop(context,true);

                  },
                  child: Text(btn),
              ),
          ],
        ),
      )
    );
  }
  _insert(){
    // task.id = 1;
    task.todo = textController.text;
    DataBaseHelper dataBaseHelper = DataBaseHelper();
    if(task.id == null) {
      dataBaseHelper.insert(task);
    }else{
      dataBaseHelper.update(task);
    }
  }
}