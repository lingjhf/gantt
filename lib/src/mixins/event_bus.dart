
mixin EventBusMixin {
  final _map = <String, List<Function>>{};

  void on(String key, Function callback) {
    var values = _map[key];
    if (values == null) {
      _map[key] = [callback];
      return;
    }
    values.add(callback);
  }

  void emit(String key, [arg]) {
    var values = _map[key];
    if (values == null || values.isEmpty) {
      return;
    }
    for (var value in values) {
      value.call(arg);
    }
  }
}
