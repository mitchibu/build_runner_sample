import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:todo_reporter/todo_reporter.dart';

class ResourceGenerator extends GeneratorForAnnotation<Resources> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if(element is! ClassElement) {
      throw InvalidGenerationSourceError('Generator can not target \'${element.name}\'.');
    }

    var buffer = StringBuffer();
    buffer.write(_generate(Directory(annotation.read('path').stringValue)));
    return buffer.toString();
  }

  String _generate(Directory dir) {
    final StringBuffer buffer = StringBuffer();
    final Map<String, _Info> map = {};

    dir.listSync(recursive: true).forEach((entity) {
      //if(entity.statSync().type == FileSystemEntityType.directory) return;
      if(FileSystemEntity.isDirectorySync(entity.path)) return;

      String suffix = entity.parent.path.replaceAll(dir.path, '');
      if(suffix.isNotEmpty) suffix = suffix.replaceAll(Platform.pathSeparator, '\$');

      _Info info = map[suffix]??_Info();
      map[suffix] = info;

      Map<String, dynamic> json = jsonDecode(File(entity.path).readAsStringSync());
      json.forEach((name, value) {
        if(value is String) {
          info.stringMap[name] = value;
        } else {
          info.valueMap[name] = value;
        }
      });
    });
    map.forEach((suffix, info) {
      if(info.stringMap.isNotEmpty) buffer.write(_createClass('_\$String', suffix, info.stringMap));
      if(info.valueMap.isNotEmpty) buffer.write(_createClass('_\$Value', suffix, info.valueMap));
    });

//typedef Instantiate<T> = T Function();
//Map<String, Instantiate<_$String>> D = {
//  '': () => _$String(),
//  'ja': () => _$String$ja()
//};
    buffer.writeln('typedef Instantiate<T> = T Function();');
    buffer.writeln('Map<String, Instantiate<_\$String>> _\$StringMap = {');
    buffer.writeln('};');
    return buffer.toString();
  }

  String _createClass(String className, String suffix, Map<String, dynamic> fields) {
    var buffer = StringBuffer();
    List<String> params = [];
    if(suffix.isEmpty) {
      buffer.writeln('class $className {');
      fields.forEach((name, value) {
        buffer.writeln('  final ${value.runtimeType} $name;');
        value = value is String ? '\'$value\'' : value;
        params.add('this.$name = $value');
      });
      if(params.isEmpty) {
        buffer.writeln('  const $className();');
      } else {
        buffer.writeln('  const $className({');
        params.forEach((param) {
          buffer.writeln('    $param,');
        });
        buffer.writeln('  });');
      }
    } else {
      buffer.writeln('class $className$suffix extends $className {');
      buffer.writeln('  const $className$suffix() : super(');
      fields.forEach((name, value) {
        value = value is String ? '\'$value\'' : value;
        buffer.writeln('    $name: $value,');
      });
      buffer.writeln('  );');
    }
    buffer.writeln('}');
    return buffer.toString();
  }
}

class _Info {
  final Map<String, String> stringMap = {};
  final Map<String, dynamic> valueMap = {};
}
