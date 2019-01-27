class Todo {
  final String name;
  final String todoUrl;

  const Todo(this.name, {this.todoUrl}) : assert(name != null);
}

class Entity {
  const Entity();
}

class Dao {
  const Dao();
}

class Query {
  final String sql;
  const Query(this.sql);
}

class Resources {
  final String path;
  const Resources({this.path = 'resources'});
}

class StringResources {
  final String name;
  final String lang;
  const StringResources({
    this.name = 'resources/string.json',
    this.lang = ''
  });
}
