import 'package:epayment_templete/utils/model.dart';

class TodoItem extends Model {

  static String table = 'todo_items';

  int id;
  String task;
  int complete;

  TodoItem({ this.id, this.task, this.complete });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'task': task,
      'complete': complete
    };

    if (id != null) { map['id'] = id; }
    return map;
  }

  static TodoItem fromMap(Map<String, dynamic> map) {

    return TodoItem(
        id: map['id'],
        task: map['task'],
        complete: map['complete']
    );
  }
}
