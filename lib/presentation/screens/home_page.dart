import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/data/models/todo_model.dart';
import 'package:todo/data/services/todo_service.dart';
import 'package:todo/presentation/screens/add_todo_screen.dart';

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
          onPressed: ()async {
            final bool setS = await
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddTODOScreen(),
            ));
            if(setS??false){
              setState(() {

              });
            }
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add, size: 30),
        ),
      ),
      body: FutureBuilder(
        future: _openBox(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(todoBox.isEmpty){
              return const Center(child: Text("No TODO TASK"),);
            }
            return ListView.builder(
                 itemCount: todoBox.length,
                itemBuilder: (context,index){
                   TODOModel todo = todoBox.getAt(index)!;
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Row(
                      children: [
                        Text(todo.description),
                        const SizedBox(width: 10,),
                        Text("Date: ${todo.date.month}/${todo.date.day}/${todo.date.year}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: ()async{
                              final bool setS=  await
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditTODOScreen(
                                  todoModel: todo,
                                  index: index,
                                ),
                              ));
                              if(setS??false){
                                setState(() {

                                });
                              }
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async{
                            await TodoService().deleteTodo(index);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  );
                }
            );
          }
          return const Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}
