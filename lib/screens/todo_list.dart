import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do_app/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: Visibility(
        visible: isLoading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEditPage(context,item);
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        child: Text('Edit'),
                        value: 'edit',
                      ),
                      const PopupMenuItem(
                        child: Text('Delete'),
                        value: 'delete',
                      )
                    ];
                  }),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddPage(context),
        label: Text('Add Todo'),
      ),
    );
  }

  void navigateToEditPage(BuildContext context,Map item) {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
    Navigator.push(context, route);
  }
 Future <void> navigateToAddPage(BuildContext context)async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode==200){
    final filtered = items.where((element) => element['_id']!=id).toList();
    setState(() {
      items = filtered;
    });
    }else{
    showErrorMessage('Unable to Delete');
    }
  }

  Future<void> fetchTodo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
 
  }


  void showErrorMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.red),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
