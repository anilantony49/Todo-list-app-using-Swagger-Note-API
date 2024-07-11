import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/services/todo_services.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<TodoInitialFetchEvent>(_onInitialFetch);
    on<TodoAddEvent>(_onAddTodo);
    on<TodoUpdateEvent>(_onUpdateTodo);
    on<TodoDeleteEvent>(_onDeleteTodo);
  }

// event handler
  Future<void> _onInitialFetch(
      TodoInitialFetchEvent event, Emitter<TodoState> emit) async {
    try {
      final todos = await TodoService.fetchTodo();
      emit(TodoLoadSuccess(todos: todos ?? []));
    } catch (e) {
      emit(TodoOperationFailureState());
    }
  }

  Future<void> _onAddTodo(TodoAddEvent event, Emitter<TodoState> emit) async {
    final isSuccess = await TodoService.addTodo(event.todo);
    if (isSuccess) {
      emit(TodoOperationSuccessState());
    } else {
      emit(TodoOperationFailureState());
    }
  }

  Future<void> _onUpdateTodo(
      TodoUpdateEvent event, Emitter<TodoState> emit) async {
    final isSuccess =
        await TodoService.updateTodo(event.todo.id ?? '', event.todo);
    if (isSuccess) {
      emit(TodoOperationSuccessState());
    } else {
      emit(TodoOperationFailureState());
    }
  }

  Future<void> _onDeleteTodo(
      TodoDeleteEvent event, Emitter<TodoState> emit) async {
    final isSuccess = await TodoService.deleteById(event.todoId);
    if (isSuccess) {
      emit(TodoOperationSuccessState());
    } else {
      emit(TodoOperationFailureState());
    }
  }
}
