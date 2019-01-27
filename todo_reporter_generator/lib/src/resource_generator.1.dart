import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:todo_reporter/todo_reporter.dart';

class ResourceGeneratorBK extends GeneratorForAnnotation<Resources> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if(element is! ClassElement) {
      throw InvalidGenerationSourceError('xxx');
    }

    var classElement = element as ClassElement;
    var className = classElement.name;
    var fields = classElement.fields;

    var buffer = StringBuffer();

    final Map<String, String> stringMap = {};
    final Map<String, int> intMap = {};
    final Map<String, double> doubleMap = {};
    final Map<String, bool> boolMap = {};
    Directory('resources').listSync().forEach((entitiy) {
      Map<String, dynamic> json = jsonDecode(File(entitiy.path).readAsStringSync());
      json.forEach((name, value) {
        if(value is String) {
          stringMap[name] = value;
        } else if(value is int) {
          intMap[name] = value;
        } else if(value is double) {
          doubleMap[name] = value;
        } else if(value is bool) {
          boolMap[name] = value;
        }
      });
    });
    buffer.writeln('//----->');
    buffer.write(_createClass('_\$String', stringMap));
    buffer.write(_createClass('_\$Integer', intMap));
    buffer.writeln('//<-----');

    Map<String, dynamic> testMap = jsonDecode(File('resources/test.json').readAsStringSync());
    testMap.forEach((k, v) {
      buffer.writeln('//k: $k');
      buffer.writeln('//v: $v');
      buffer.writeln('//runtimeType: ${v.runtimeType}');
    });

    buffer.writeln('//${annotation.read('path').stringValue}');
    var entities = Directory('resources').listSync();
    buffer.writeln('//entities: $entities');
    entities.where((entity) {
      buffer.writeln('//entity: $entity');
      if(entity.statSync().type != FileSystemEntityType.file) return false;
      // var match = RegExp('string\.(.+)\.json').firstMatch(entity.uri.pathSegments.last);
      // if(match == null) return false;
      return entity.uri.pathSegments.last.startsWith(RegExp('string(\.(.+))*\.json\$'));
    }).forEach((entity) {
      buffer.writeln('//result: $entity');
     var match = RegExp('string(\.(.+))*\.json\$').firstMatch(entity.uri.pathSegments.last);
     if(match == null) return;
     buffer.writeln('//${match.groupCount}');
     for(int i = 0; i < match.groupCount; ++ i) {
       buffer.writeln('//$i ${match.group(i)}');
     }
     //var lang = match.group(1);
    });
    var s = File('lib/main.dart').readAsStringSync();
    buffer.writeln('//method');
    classElement.methods.forEach((method) {
      buffer.writeln('//${method}');
    });
    buffer.writeln('//field');
    classElement.fields.forEach((field) {
      field.metadata.forEach((meta) {
        buffer.writeln('//meta: $meta');
        if(TypeChecker.fromRuntime(StringResources).isAssignableFromType(meta.constantValue.type)) {
          //var lang = meta.constantValue.getField('lang').toStringValue();
          var lang = meta.constantValue.getField('lang').toStringValue();
          var name = '_\$String';
          if(lang.isNotEmpty) name = '$name\$$lang';
          var json = _loadJson(meta.constantValue.getField('name').toStringValue());
          buffer.writeln('class $name {');
          buffer.writeln('  const $name();');
          buffer.writeln('  final String \$lang = \'$lang\';');
          json.forEach((k, v) {
            buffer.writeln('  final String $k = \'$v\';');
          });
          buffer.writeln('}');
        }
      });
      buffer.writeln('//${field}');
    });
    buffer.writeln('/*');
    buffer.writeln(s);
    buffer.writeln('*/');

/*    buffer.writeln('$className get${className}FromMap(Map<String, dynamic> map, {prefix = \'\'}) {');
    buffer.writeln('  var entity = ${className}(); ');
    fields.forEach((field) {
      buffer.writeln('  entity.${field.name} = map[\'\${prefix}${field.name}\'];');
    });
    buffer.writeln('  return entity;');
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln('List<${className}> get${className}FromList(List<Map<String, dynamic>> maps, {prefix = \'\'}) {');
    buffer.writeln('  List<${className}> entities = [];');
    buffer.writeln('  maps.forEach((map) {');
    buffer.writeln('    entities.add(get${className}FromMap(map, prefix: prefix));');
    buffer.writeln('  });');
    buffer.writeln('  return entities;');
    buffer.writeln('}');
    buffer.writeln('');
    buffer.writeln('Map<String, dynamic> get${className}ToMap($className entity) {');
    buffer.writeln('  return {');
    fields.forEach((field) {
      buffer.writeln('    \'${field.name}\': entity.${field.name},');
    });
    buffer.writeln('  };');
    buffer.writeln('}');*/
    return buffer.toString();
  }

  Map<String, dynamic> _loadJson(String name) => jsonDecode(File(name).readAsStringSync());

  _listFiles(String name) => Directory(name).listSync().where((entity) {
      if(entity.statSync().type != FileSystemEntityType.file) return false;
      return entity.uri.pathSegments.last.startsWith(RegExp('(strings\.(.+)\.json|values.json)\$'));
    });

  String _createClass(String className, Map<String, dynamic> fields) {
    var buffer = StringBuffer();
    List<String> params = [];
    buffer.writeln('class $className {');
    fields.forEach((name, value) {
      buffer.writeln('  final ${value.runtimeType} $name;');
      value = value is String ? '\'$value\'' : value;
      params.add('this.$name = $value');
    });
    buffer.writeln('  const $className({');
    params.forEach((param) {
      buffer.writeln('    $param,');
    });
    buffer.writeln('  });');
    buffer.writeln('}');
    return buffer.toString();
  }
}
