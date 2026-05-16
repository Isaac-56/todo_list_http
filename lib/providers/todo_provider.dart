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
    } catch (e) {
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }


  Future<void> addTodo(Todo todo) async {
    _setLoading(true);
    _clearMessage();
    try {
      final newTodo = await _apiService.createTodo(todo);
      _todos.insert(0, newTodo);
      _message = 'Created: ${newTodo.title}';
    } catch (e) {
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }


  Future<void> updateTodo(int id, Todo todo) async {
    _setLoading(true);
    _clearMessage();
    try {
      final updated = await _apiService.updateTodo(id, todo);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) _todos[index] = updated;
      _message = 'Updated: ${updated.title}';
    } catch (e) {
      _message = 'Error: $e';
    } finally {
      _setLoading(false);
    }
  }


  Future<void> removeTodo(int id) async {
    _setLoading(true);
    _clearMessage();
    try {
      await _apiService.deleteTodo(id);
      _todos.removeWhere((t) => t.id == id);
      _message = 'Deleted todo with id $id';
    } catch (e) {
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