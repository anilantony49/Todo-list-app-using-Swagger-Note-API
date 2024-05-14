import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 8,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: submitData, child: Text('Submit'))
        ],
      ),
    );
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "descriptiion": description,
      "is_completed": false,
    };

    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      // print('Success');
      showSuccsessMessage('Todo added Successfully');
    } else {
      // print('failed');
      showErrorMessage(response.body);
    }

    // print(response.statusCode);
  }

  void showSuccsessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
