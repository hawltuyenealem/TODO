import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:todo/data/models/todo_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Edit Todo Integration Test', () {
    late Box<TODOModel> todoBox;

    setUpAll(() async {
      var path = "/assets/db";
      if (!kIsWeb) {
        var appDocDir = await path_provider.getApplicationDocumentsDirectory();
        path = appDocDir.path;
      }
      await Hive.initFlutter();
      Hive.init(path);
      Hive.registerAdapter(TODOModelAdapter());
    });

    setUp(() async {
      todoBox = await Hive.openBox<TODOModel>('todos');
    });

    tearDown(() {
      Hive.close();
    });

    test('Add Todo Test', () async {
      const todoTitle = 'Test ';
      const todoDescription = "description";
      await todoBox.add(TODOModel(
          title: todoTitle,
          description: todoDescription,
          id: DateTime.now().microsecond.toString(),
          date: DateTime.now()));

      final savedTodo = todoBox.values.first;
      expect(savedTodo.title, todoTitle);
    });

    test('Edit Todo Test', () async {
      const updatedTitle = 'Updated TodoTitle';
      const todoDescription = "description";
      final todo = TODOModel(
          title: "initial title",
          description: todoDescription,
          id: DateTime.now().microsecond.toString(),
          date: DateTime.now());
      final index = await todoBox.add(todo);

      final updatedTodo = TODOModel(
          title: updatedTitle,
          description: todoDescription,
          id: DateTime.now().microsecond.toString(),
          date: DateTime.now());
      todoBox.putAt(index, updatedTodo);

      final editedTodo = todoBox.getAt(index);
      expect(editedTodo!.title, updatedTitle);
    });
  });
}
