import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_app/model/todo_model.dart';

class TodoService {
  static Future<bool> deleteById(String id) async {
    try {
      final url = 'https://api.nstack.in/v1/todos/$id';
      final uri = Uri.parse(url);
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete todo. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred while deleting todo: $e');
      return false;
    }
  }

  static Future<List<TodoModel>?> fetchTodo() async {
    try {
      const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
      final uri = Uri.parse(url);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print(response.body);
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final items = json['items'] as List<dynamic>;
        final todos = items
            .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return todos;
      } else {
        print('Failed to fetch todos. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching todos: $e');
      return null;
    }
  }

  static Future<bool> updateTodo(String id, TodoModel todo) async {
    try {
      final url = "https://api.nstack.in/v1/todos/$id";
      final uri = Uri.parse(url);
      final body = jsonEncode({
        'title': todo.title,
        'description': todo.description,
        'is_completed': todo.isCompleted,
      });
      final response = await http
          .put(uri, body: body, headers: {'Content-Type': 'application/json'});

      print(response.body);
      return response.statusCode == 200;
    } catch (e) {
      print('Error occurred while updating todo: $e');
      return false;
    }
  }

  static Future<bool> addTodo(TodoModel todo) async {
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final body = jsonEncode({
      'title': todo.title,
      'description': todo.description,
      'is_completed': todo.isCompleted,
    });
    final response = await http
        .post(uri, body: body, headers: {'Content-Type': 'application/json'});
    print(response.body);
    return response.statusCode == 201;
  }
}

Future<bool> addTodo(TodoModel todo) async {
  try {
    const url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final body = jsonEncode({
      'title': todo.title,
      'description': todo.description,
      'is_completed': todo.isCompleted,
    });
    final response = await http
        .post(uri, body: body, headers: {'Content-Type': 'application/json'});

    print(response.body);
    return response.statusCode == 201;
  } catch (e) {
    print('Error occurred while adding todo: $e');
    return false;
  }
}
