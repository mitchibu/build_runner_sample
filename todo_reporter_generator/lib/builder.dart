import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:todo_reporter_generator/src/dao_generator.dart';
import 'package:todo_reporter_generator/src/entity_generator.dart';
import 'package:todo_reporter_generator/src/resource_generator.dart';

Builder todoReporter(BuilderOptions options) =>
    SharedPartBuilder([
      EntityGenerator(),
      DaoGenerator(),
      ResourceGenerator(),], 'todo_reporter');
