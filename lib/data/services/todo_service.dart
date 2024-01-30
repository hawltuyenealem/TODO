import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/models/todo_model.dart';


class TodoService {
  static final String _boxName = 'todos';

  Future<void> addTodo(TODOModel todo) async {
    final box = await Hive.openBox<TODOModel>(_boxName);
    await box.add(todo);
  }

  Future<List<TODOModel>> getAllTodos() async {
    final box = await Hive.openBox<TODOModel>(_boxName);
    final todos = box.values.toList();
    return todos;
  }

  Future<void> updateTodo(TODOModel updatedTodo,int index) async {
    final box = await Hive.openBox<TODOModel>(_boxName);
    await box.putAt(index, updatedTodo);
  }

  Future<void> deleteTodo(String id) async {
    final box = await Hive.openBox<TODOModel>(_boxName);
    await box.delete(id);
  }
}