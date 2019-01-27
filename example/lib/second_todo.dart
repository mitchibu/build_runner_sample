import 'package:example/todo.dart';
import 'package:todo_reporter/todo_reporter.dart';

part 'second_todo.g.dart';
//@Todo('Second todo to be implemented')
@Dao()
abstract class TestDao {
  @Query('select * from table')
  List<Test> getAll();

  @Query('select * from table where id=\$id')
  List<Test> getById(int id);
}
/*
@Todo(
  'More and more todos',
  todoUrl: 'https://stackoverflow.com',
)
class MoreTodos {
  final String something;

  const MoreTodos(this.something);
}
*/