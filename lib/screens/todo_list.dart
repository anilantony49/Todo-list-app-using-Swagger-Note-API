import 'package:flutter/material.dart';
import 'package:to_do_app/screens/add_page.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddPage(context),
        label: Text('Add Todo'),
      ),
    );
  }

  void navigateToAddPage(BuildContext context){
    final route = MaterialPageRoute(builder: (context)=>AddTodoPage());
    Navigator.push(context, route);
  }
}
