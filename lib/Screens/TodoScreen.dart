import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:lista_de_tarefas/widgets/TextFieldWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;
  final int index;

  TodoItem({Key key, @required this.todo, @required this.index})
      : super(key: key);
  @override
  _TodoItemState createState() => _TodoItemState(todo, index);
}

class _TodoItemState extends State<TodoItem> {
  Todo _todo;
  int _index;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  _TodoItemState(Todo todo, int index) {
    this._todo = todo;
    this._index = index;
    if (todo != null) {
      _titleController.text = _todo.title;
      _descriptionController.text = _todo.description;
    }
  }

  _saveItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Todo> list = [];
    var data = prefs.getString('list');

    if (data != null) {
      var objs = jsonDecode(data) as List;
      list = objs.map((obj) => Todo.fromJson(obj)).toList();
    }

    _todo = Todo.fromTituloDescricao(
        _titleController.text, _descriptionController.text);
    if (_index != -1) {
      list[_index] = _todo;
    } else {
      list.add(_todo);
    }

    prefs.setString('list', jsonEncode(list));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Itens'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTextField(
              c: _titleController,
              label: 'Título',
            ),
            SizedBox(
              height: 10,
            ),
            buildTextField(
              c: _descriptionController,
              label: 'Descrição',
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Salvar',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              onPressed: () {
                _saveItem();
              },
            )
          ],
        ),
      ),
    );
  }
}
