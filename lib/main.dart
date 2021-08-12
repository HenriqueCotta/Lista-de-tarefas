import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState(){
    super.initState();

    _readData().then((data) => null){
      setState(() {
        _toDoList = json.decode(data);
      });
    };
  }

  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
    newToDo["title"] = _toDoController.text;
    _toDoController.text = "";
    newToDo["ok"] = false;
    _toDoList.add(newToDo);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);

    final file = await _getFile(); 
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: "Nova Tarefa",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _addToDo,
                child: Text("ADD"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                ),
              )
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _toDoList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                        _toDoList[index]["ok"] ? Icons.check : Icons.error,
                      ),
                    ),
                    onChanged: (c){
                      setState(() {
                        _toDoList[index]["ok"] = c;
                        _saveData();
                      });
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
