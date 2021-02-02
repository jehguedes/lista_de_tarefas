import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Screens/TodoScreen.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> list = [];

  @override
  void initState() {
    super.initState();
    _reloadList();
  }

  _reloadList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('list');
    if (data != null) {
      setState(() {
        var objs = jsonDecode(data) as List;
        list = objs.map((obj) => Todo.fromJson(obj)).toList();
      });
    }
  }

  _removeItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('list', jsonEncode(list)));
  }

  _checkItem(int index) {
    setState(() {
      if (list[index].status == 'A') {
        list[index].status = 'F';
      } else
        list[index].status = 'A';
    });
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('list', jsonEncode(list)));
  }

  _showAlertDialog(
      BuildContext context, String conteudo, Function f, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmação'),
          content: Text(conteudo),
          actions: [
            FlatButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.pop(context)),
            FlatButton(
                child: Text('Confirmar'),
                onPressed: () {
                  f(index);
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reloadList,
          )
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(list[index].title,
                style: list[index].status == 'F'
                    ? TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.lineThrough)
                    : null),
            subtitle: Text(list[index].description),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TodoItem(todo: list[index], index: index),
                ),
              ).then((value) => _reloadList());
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _showAlertDialog(context, 'Certeza que deseja excluir?',
                          _removeItem, index);
                    }),
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      _showAlertDialog(
                          context,
                          'O item foi realmente finalizado?',
                          _checkItem,
                          index);
                    }),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoItem(
                  todo: null,
                  index: -1,
                ),
              )).then((value) => _reloadList());
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
