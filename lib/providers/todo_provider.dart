import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class TodoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Todo> _todos = [];
  bool _isLoading = false;
  String _message = '';
  Todo? _singleTodo;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get message => _message;
  Todo? get singleTodo => _singleTodo;

  Future<void> fetchTodos() async {
    _setLoading(true);
    _clearMessage();
    try {
      _todos = await _apiService.getTodos();
      _message = 'Fetched ${_todos.length} todos';
    } catch (e) {
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchTodoById(int id) async {
    _setLoading(true);
    _clearMessage();
    _singleTodo = null;
    try {
      _singleTodo = await _apiService.getTodoById(id);
      _message = 'Fetched: ${_singleTodo!.title}';
    } catch (e) {
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTodo(Todo todo) async {
    List<Todo> previousTodos = List.from(_todos);
    _setLoading(true);
    _clearMessage();
    try {
      final newTodo = await _apiService.createTodo(todo);
      _todos = [newTodo, ...previousTodos].take(5).toList();
      _message = 'Added: ${newTodo.title}';
    } catch (e) {
      _todos = previousTodos;
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTodo(int id, Todo todo) async {
    List<Todo> previousTodos = List.from(_todos);
    _setLoading(true);
    _clearMessage();
    try {
      final updated = await _apiService.updateTodo(id, todo);
      _todos = previousTodos.map((t) => t.id == id ? updated : t).toList();
      if (_singleTodo?.id == id) _singleTodo = updated;
      _message = 'Updated: ${updated.title}';
    } catch (e) {
      _todos = previousTodos;
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> removeTodo(int id) async {
    List<Todo> previousTodos = List.from(_todos);
    _setLoading(true);
    _clearMessage();
    try {
      await _apiService.deleteTodo(id);
      _todos = previousTodos.where((t) => t.id != id).toList();
      if (_singleTodo?.id == id) _singleTodo = null;
      _message = 'Deleted todo with id $id';
    } catch (e) {
      _todos = previousTodos;
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearMessage() {
    _message = '';
    notifyListeners();
  }
}