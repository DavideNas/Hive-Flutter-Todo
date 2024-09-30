import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'models/todo.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //
  final TextEditingController _textEditingController = TextEditingController();
  //
  Box? _todosBox;
  //

  @override
  void initState() {
    super.initState();
    Hive.openBox("todos_box").then((box) {
      setState(() {
        _todosBox = box;
      });
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUI() {
    if (_todosBox == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ValueListenableBuilder(
      valueListenable: _todosBox!.listenable(),
      builder: (context, box, widget) {
        final todosKeys = box.keys.toList();
        // debugPrint("la lista ha → ${box.keys.length} elementi");
        //
        return SizedBox.expand(
          child: ListView.builder(
            itemCount: todosKeys.length,
            itemBuilder: (context, index) {
              Todo todo = _todosBox!.get(
                todosKeys[index],
              ) as Todo;
              return ListTile(
                title: Text("${index.toString()} - "), //${todo.content}"),
                //subtitle: Text(todo.time),
                onLongPress: () async {
                  await _todosBox!.delete(
                    todosKeys[index],
                  );
                },
                // trailing: Checkbox(
                //   value: todo["isDone"],
                //   onChanged: (value) async {
                //     todo["isDone"] = value;
                //     await _todosBox!.put(todosKeys[index], todo);
                //   },
                // ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        //
        return AlertDialog(
          title: const Text('Add a todo'),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(hintText: "Todo..."),
          ),
          actions: [
            MaterialButton(
              color: Colors.amber,
              textColor: Colors.white,
              child: const Text('OK'),
              onPressed: () {
                int? index = _todosBox?.length;
                (index != null) ? index : 0;
                _todosBox?.put(
                  index,
                  Todo(_textEditingController.text, DateTime.now().toIso8601String(), false),
                );
                debugPrint("new length of list box is → ${_todosBox?.length}");
                Navigator.pop(context);
                _textEditingController.clear();
              },
            )
          ],
        );
      },
    );
  }
}
