import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:todo_reporter/todo_reporter.dart';

class DaoGenerator extends GeneratorForAnnotation<Dao> {
  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if(element is! ClassElement) {
      throw InvalidGenerationSourceError('xxx');
    }

    var classElement = element as ClassElement;
    var className = classElement.name;
    var methods = classElement.methods;
    var buffer = StringBuffer();
    buffer.writeln('class ${className}Impl extends $className {');
    methods.forEach((method) {
      var b = StringBuffer();
      method.parameters.forEach((e) {
        if(b.isNotEmpty) b.write(',');
        b.write('${e.type} ${e.name}');
      });

      String sql;
      method.metadata.forEach((meta) {
        if(TypeChecker.fromRuntime(Query).isAssignableFromType(meta.constantValue.type)) {
          sql = meta.constantValue.getField('sql').toStringValue();
        }
      });

      if(method.isAbstract && sql.isNotEmpty) {
        buffer.writeln('  @override');
        buffer.writeln('  ${method.returnType} ${method.name}(${b.toString()}) {');
        buffer.writeln('    String a = \'$sql\';');
        buffer.writeln('  }');
        buffer.writeln('//${method.unit}');
        buffer.writeln('//${Query}');
      }
    });
    buffer.writeln('}');
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

  // Query _getQuery(MethodElement e) {
  //   e.metadata.forEach((meta) {
  //     if(TypeChecker.fromRuntime(Query).isAssignableFromType(meta.constantValue.type)) {
  //       const String sql = meta.constantValue.getField('sql').toStringValue();
  //       return const Query(sql);
  //     }
  //   });
  // }
}
