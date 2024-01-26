import 'package:fast_app_base/common/data/memory/todo_status.dart';

class Todo {
  int id;
  String title;
  final DateTime createdTime;
  DateTime? modifyTime;
  DateTime dueDate;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    required this.dueDate,
    this.status = TodoStatus.incomplete,
  }) : createdTime = DateTime.now();
}
