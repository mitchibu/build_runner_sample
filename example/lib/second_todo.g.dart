// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'second_todo.dart';

// **************************************************************************
// DaoGenerator
// **************************************************************************

class TestDaoImpl extends TestDao {
  @override
  List<Test> getAll() {
    String a = 'select * from table';
  }

//import 'package:example/todo.dart'; import 'package:todo_reporter/todo_reporter.dart'; part 'second_todo.g.dart'; @Dao() abstract class TestDao {@Query('select * from table') List<Test> getAll(); @Query('select * from table where id=\$id') List<Test> getById(int id);}
//Query
  @override
  List<Test> getById(int id) {
    String a = 'select * from table where id=$id';
  }
//import 'package:example/todo.dart'; import 'package:todo_reporter/todo_reporter.dart'; part 'second_todo.g.dart'; @Dao() abstract class TestDao {@Query('select * from table') List<Test> getAll(); @Query('select * from table where id=\$id') List<Test> getById(int id);}
//Query
}
