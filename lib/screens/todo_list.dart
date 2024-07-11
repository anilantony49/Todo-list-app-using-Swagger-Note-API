import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/todo_bloc.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/screens/add_page.dart';

import 'package:to_do_app/widget/todo_card.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoInitial || state is TodoOperationSuccessState) {
            context.read<TodoBloc>().add(TodoInitialFetchEvent());
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TodoLoadSuccess) {
            final todos = state.todos;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TodoBloc>().add(TodoInitialFetchEvent());
              },
              child: Visibility(
                visible: todos.isNotEmpty,
                replacement: const Center(
                  child: Text('No Todo Item'),
                ),
                child: ListView.builder(
                    itemCount: todos.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      // final id = item['_id'] as String;
                      return TodoCard(
                          index: index,
                          item: todo,
                          navigateEdit: (todo) =>
                              navigateToEditPage(context, todo),
                          deleteById: deleteById);
                    }),
              ),
            );
          } else if (state is TodoOperationFailureState) {
            context.read<TodoBloc>().add(TodoInitialFetchEvent());
            return const Center(
              child: Text('Failed to load todos'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigateToAddPage(context),
        label: const Text('Add Todo'),
      ),
    );
  }

  void navigateToEditPage(BuildContext context, TodoModel todo) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddTodoPage(
                todo: todo,
              )),
    );

    if (result == true) {
      context.read<TodoBloc>().add(TodoInitialFetchEvent());
    }
  }

  Future<void> navigateToAddPage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );

    if (result == true) {
      context.read<TodoBloc>().add(TodoInitialFetchEvent());
    }
  }

  void deleteById(BuildContext context, String id) {
    context.read<TodoBloc>().add(TodoDeleteEvent(todoId: id));
  }
}
