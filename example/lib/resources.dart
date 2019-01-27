import 'dart:ui';

import 'package:todo_reporter/todo_reporter.dart';

part 'resources.g.dart';

MyResources R = MyResources();

typedef Instantiate<T> = T Function();

Map<String, Instantiate<_$String>> D = {
  '': () => _$String(),
  'ja': () => _$String$ja()
};

@Resources(path: 'resources')
class MyResources {
  void setLocale(Locale locale) {
    string = D[locale.languageCode]() ?? D['']();
  }

  _$String string;
  final _$Value value = _$Value();

  @StringResources(name: 'resources/string.json')
  final _$String string_ = _$String();
  @StringResources(name: 'resources/string.ja.json', lang: 'ja')
  final _$String string_ja = _$String$ja();
}


void test() {
  R.string.test;
}
