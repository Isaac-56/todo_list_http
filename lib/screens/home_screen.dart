import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  bool _completed = false;
  int _userId = 1;

  final _idController = TextEditingController();
  final _updateIdController = TextEditingController();
  final _updateTitleController = TextEditingController();
  bool _updateCompleted = false;
  final _deleteIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do CRUD (HTTP + Provider)'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            if (todoProvider.isLoading)
              const LinearProgressIndicator(),
            
            if (todoProvider.message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey[200],
                child: Text(todoProvider.message),
              ),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => todoProvider.fetchTodos(),
                  child: const Text('GET ALL'),
                ),
                ElevatedButton(
                  onPressed: () => _showFetchSingleDialog(todoProvider),
                  child: const Text('GET SINGLE'),
                ),
                ElevatedButton(
                  onPressed: () => _showCreateDialog(todoProvider),
                  child: const Text('CREATE'),
                ),
                ElevatedButton(
                  onPressed: () => _showUpdateDialog(todoProvider),
                  child: const Text('UPDATE'),
                ),
                ElevatedButton(
                  onPressed: () => _showDeleteDialog(todoProvider),
                  child: const Text('DELETE'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            if (todoProvider.todos.isNotEmpty)
              const Text(
                'All Todos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (ctx, i) {
                  final todo = todoProvider.todos[i];
                  return Card(
                    child: ListTile(
                      title: Text(todo.title),
                      subtitle: Text('ID: ${todo.id} | User: ${todo.userId}'),
                      trailing: Icon(
                        todo.completed ? Icons.check_circle : Icons.pending,
                        color: todo.completed ? Colors.green : Colors.orange,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (todoProvider.singleTodo != null)
              Card(
                margin: const EdgeInsets.only(top: 16),
                color: Colors.yellow[100],
                child: ListTile(
                  title: Text(todoProvider.singleTodo!.title),
                  subtitle: Text(
                    'ID: ${todoProvider.singleTodo!.id}\nCompleted: ${todoProvider.singleTodo!.completed}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFetchSingleDialog(TodoProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Get Single Todo'),
        content: TextField(
          controller: _idController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Todo ID'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(_idController.text);
              if (id != null) {
                provider.fetchTodoById(id);
              }
              _idController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Fetch'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(TodoProvider provider) {
    _titleController.clear();
    _completed = false;
    _userId = 1;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Todo'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              Row(
                children: [
                  const Text('Completed: '),
                  Checkbox(
                    value: _completed,
                    onChanged: (val) => setState(() => _completed = val!),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('User ID: '),
                  Expanded(
                    child: Slider(
                      value: _userId.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (val) => setState(() => _userId = val.toInt()),
                    ),
                  ),
                  Text('$_userId'),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newTodo = Todo(
                  userId: _userId,
                  title: _titleController.text,
                  completed: _completed,
                );
                provider.addTodo(newTodo);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(TodoProvider provider) {
    _updateIdController.clear();
    _updateTitleController.clear();
    _updateCompleted = false;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _updateIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Todo ID to update'),
            ),
            TextField(
              controller: _updateTitleController,
              decoration: const InputDecoration(labelText: 'New Title'),
            ),
            Row(
              children: [
                const Text('Completed: '),
                Checkbox(
                  value: _updateCompleted,
                  onChanged: (val) => setState(() => _updateCompleted = val!),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(_updateIdController.text);
              if (id != null) {
                final updatedTodo = Todo(
                  userId: 1,
                  title: _updateTitleController.text,
                  completed: _updateCompleted,
                );
                provider.updateTodo(id, updatedTodo);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(TodoProvider provider) {
    _deleteIdController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Todo'),
        content: TextField(
          controller: _deleteIdController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Todo ID to delete'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(_deleteIdController.text);
              if (id != null) {
                provider.removeTodo(id);
              }
              _deleteIdController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
