import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/bloc/todo_bloc.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatelessWidget {
  final TodoModel? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final isEdit = todo != null;
    if (isEdit) {
      titleController.text = todo!.title;
      descriptionController.text = todo!.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
        if (state is TodoOperationSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showSuccsessMessage(context,
                message: isEdit
                    ? 'Todo updated successfully'
                    : 'Todo added successfully');
            Navigator.pop(context);
          });
        } else if (state is TodoOperationFailureState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorMessage(context,
                message:
                    isEdit ? 'Todo update failed' : 'Todo addition failed');
          });
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Description',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              // maxLength: 8,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (isEdit) {
                    _updateData(
                        context, todo!, titleController, descriptionController);
                  } else {
                    _submitData(
                        context, titleController, descriptionController);
                  }
                },
                child: Text(isEdit ? 'Update' : 'Submit'))
          ],
        );
      }),
    );
  }

  void _updateData(
      BuildContext context,
      TodoModel todo,
      TextEditingController titleController,
      TextEditingController descriptionController) {
    final updatedTodo = TodoModel(
      id: todo.id,
      title: titleController.text,
      description: descriptionController.text,
      // isCompleted: todo.isCompleted,
    );
     context.read<TodoBloc>().add(TodoUpdateEvent(todo: updatedTodo));
     context.read<TodoBloc>().add(TodoInitialFetchEvent());
  }

  void _submitData(BuildContext context, TextEditingController titleController,
      TextEditingController descriptionController) {
    final newTodo = TodoModel(
      title: titleController.text,
      description: descriptionController.text,
      // isCompleted: false,
    );
     context.read<TodoBloc>().add(TodoAddEvent(todo: newTodo));
     context.read<TodoBloc>().add(TodoInitialFetchEvent());
  }
}
