import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  final String content;
  @HiveField(1)
  final String time;
  @HiveField(2)
  final bool isDone;

  Todo(this.content, this.time, this.isDone);
}
