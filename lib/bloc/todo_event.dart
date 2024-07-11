part of 'todo_bloc.dart';

abstract class TodoEvent {}

class TodoInitialFetchEvent extends TodoEvent {}

class TodoAddEvent extends TodoEvent {
  final TodoModel todo;

  TodoAddEvent({required this.todo});
}

class TodoUpdateEvent extends TodoEvent {
  final TodoModel todo;

  TodoUpdateEvent({required this.todo});
}

class TodoDeleteEvent extends TodoEvent {
  final String todoId;

  TodoDeleteEvent({required this.todoId});
}
