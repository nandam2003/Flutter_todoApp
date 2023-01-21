class Task{
  var id;
  late String todo;
  late bool isDone;

  Task();
  Task.withTodo({required this.todo,required this.isDone});

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
        'id':id,
      'todo':todo,
      'isDone':isDone.toString(),
    };
    return map;
  }

  Task.formMap(Map<String,dynamic> m){
    id = m["id"];
    todo = m["todo"];
    if(m["isDone"] == 'true'){
      isDone = true;
    }else{
      isDone = false;
    }
  }
 }
