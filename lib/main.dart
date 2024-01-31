import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'data/models/todo_model.dart';
import 'presentation/screens/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
  await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.initFlutter();
  Hive.registerAdapter(TODOModelAdapter());
  await Hive.openBox<TODOModel>('todos');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
