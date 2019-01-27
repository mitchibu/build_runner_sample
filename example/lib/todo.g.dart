// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// EntityGenerator
// **************************************************************************

Test getTestFromMap(Map<String, dynamic> map, {prefix = ''}) {
  var entity = Test();
  entity.id = map['${prefix}id'];
  entity.name = map['${prefix}name'];
  return entity;
}

List<Test> getTestFromList(List<Map<String, dynamic>> maps, {prefix = ''}) {
  List<Test> entities = [];
  maps.forEach((map) {
    entities.add(getTestFromMap(map, prefix: prefix));
  });
  return entities;
}

Map<String, dynamic> getTestToMap(Test entity) {
  return {
    'id': entity.id,
    'name': entity.name,
  };
}
