import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/add_todo.dart';
import 'package:flutter_application_1/database/database_helper.dart';
import 'package:flutter_application_1/data/task_data.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  var todoList;
  int count = 0;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    if(todoList == null) {
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('todos'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: populateListView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Task task;
          updateNav(title: 'Add New Todo', btn: 'Add', task:task = Task.withTodo(isDone:false));
        },
        backgroundColor: Colors.black54,
        child: const Icon(
            Icons.add
        ),
      ),
    );
  }
  updateListView() async{
    todoList = await dataBaseHelper.listOfTodoClass();
    setState(() {
      todoList = todoList;
      count = todoList.length;
    });
  }

  populateListView() {
    return ListView.builder(
      itemCount: count,
        itemBuilder: (context,index) {
        return Card(
          color: todoList[index].isDone?Colors.green:Colors.lightBlueAccent,
          child: ListTile(
            leading: IconButton(
              onPressed: () {
                  todoList[index].isDone = !todoList[index].isDone;
                _isDone(done: todoList[index]);
              },
              icon:todoList[index].isDone?const Icon(Icons.check_box):const Icon(Icons.check_box_outline_blank),
            ),
            title: Text(todoList[index].todo,
            style: TextStyle(
              decoration: todoList[index].isDone?TextDecoration.lineThrough:null,
            ),
            ),
            trailing: todoList[index].isDone?IconButton(
              onPressed: () async {
                await dataBaseHelper.delete(todoList[index]);
                await updateListView();
              },
              icon: const Icon(Icons.delete),
            ):null,
            onLongPress: () {
              updateNav(title: 'Update Todo', btn:'update', task:todoList[index]);
            },
          ),
        );
        }
    );
  }



  void updateNav({required String title,required String btn,required Task task}) async{
    flag = await Navigator.push(context,MaterialPageRoute(builder: (context){
      return AddTodo(title: title, btn: btn, task: task);
    }));
    if(flag){
      updateListView();
    }
  }

  void _isDone({required Task done})async {
    await dataBaseHelper.update(done);
    updateListView();
  }
}