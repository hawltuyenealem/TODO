import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/services/todo_service.dart';
import 'package:todo/presentation/screens/add_todo_screen.dart';
import 'package:collection/collection.dart';
import 'edit_todo_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<TODOModel> todoBox;

  @override
  void initState() {
    super.initState();
    todoBox = Hive.box<TODOModel>('todos');
  }

  bool show = true;

  Future _openBox() async {
    // await Hive.openBox<TODOModel>('todos');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("TODOS List"),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: Visibility(
          visible: show,
          child: FloatingActionButton(
            onPressed: () async {
              final bool setS =
                  await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddTODOScreen(),
              ));
              if (setS ?? false) {
                setState(() {});
              }
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder(
            future: _openBox(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (todoBox.isEmpty) {
                  return const Center(
                    child: Text("No TODO TASK"),
                  );
                }
                final today = DateTime.now();
                final tomorrow = today.add(const Duration(days: 1));

                final todayTodos = todoBox.values.where((todo) {
                  return todo.date.year == today.year &&
                      todo.date.month == today.month &&
                      todo.date.day == today.day;
                }).toList();
                final tomorrowTodos = todoBox.values.where((todo) {
                  return todo.date.year == tomorrow.year &&
                      todo.date.month == tomorrow.month &&
                      todo.date.day == tomorrow.day;
                }).toList();
                return ListView(
                  children: [
                    if (todayTodos.isNotEmpty)
                      _groups('Today', todayTodos),
                    if (todayTodos.isEmpty)
                      _noTODOGroup("Today"),
                    const SizedBox(
                      height: 50,
                    ),
                    if (tomorrowTodos.isNotEmpty)
                      _groups('Tomorrow', tomorrowTodos),
                    if (tomorrowTodos.isEmpty)
                     _noTODOGroup("Tomorrow")
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ));
  }

  Widget _groups(String title, List<TODOModel> todos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: todos.mapIndexed((index, todo) {
            return ListTile(
              title: Text(todo.title),
              subtitle: Row(
                children: [
                  Text(todo.description),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      "Date: ${todo.date.month}/${todo.date.day}/${todo.date.year}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () async {
                        final bool setS =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditTODOScreen(
                            todoModel: todo,
                            index: index,
                          ),
                        ));
                        if (setS ?? false) {
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await TodoService().deleteTodo(index);
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _noTODOGroup(String title){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Center(child: Text("No TODO TASKs")),
      ],
    );
  }
}
