import 'package:fast_app_base/common/data/memory/todo_data_notifier.dart';
import 'package:fast_app_base/common/data/memory/todo_status.dart';
import 'package:fast_app_base/common/data/memory/vo_todo.dart';
import 'package:fast_app_base/screen/dialog/d_confirm.dart';
import 'package:flutter/material.dart';
import 'package:quiver/time.dart';

import '../../../screen/main/tab/write/d_write_todo.dart';

class TodoDataHolder extends InheritedWidget {
  final TodoDataNotifier notifier;

  const TodoDataHolder({
    super.key,
    required super.child,
    required this.notifier,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static TodoDataHolder _of(BuildContext context){
    // 같은 widget tree 내에 어떤 widget이라도 (이 경우 TodoDataHolder 내 widget)
    // 제네릭 안의 데이터 타입과 일치하는 데이터를 찾아서 리턴
    TodoDataHolder inherited = (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>()!);
    return inherited;
  }

  void changeTodoStatus(Todo todo) async {
    switch(todo.status){
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog('처음 상태로 변경하시겠습니까?').show();
        result?.runIfSuccess((data) {
          todo.status = TodoStatus.incomplete;
        });
    }
    notifier.notify();
  }

  void addTodo() async{
    final result = await WriteTodoDialog().show();
    if (result != null) {
      notifier.addTodo(Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
      ));
    }
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();

    if(result!=null){
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      notifier.notify();
    }
}

  void removeTodo(Todo todo) {
    notifier.value.remove(todo);
    notifier.notify();
  }

}

extension TodoDataHolderContextExtension on BuildContext{
  TodoDataHolder get holder => TodoDataHolder._of(this);
}