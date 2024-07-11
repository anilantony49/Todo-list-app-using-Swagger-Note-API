part of 'todo_bloc.dart';

class TodoState {
  const TodoState();
}

class TodoInitial extends TodoState {}

class TodoLoadSuccess extends TodoState {
  final List<TodoModel> todos;

  const TodoLoadSuccess({required this.todos});
}

class TodoOperationSuccessState extends TodoState {}

class TodoOperationFailureState extends TodoState {}
