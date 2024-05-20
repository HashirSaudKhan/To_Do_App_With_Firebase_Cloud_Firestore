// ignore_for_file: non_constant_identifier_names

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class MyToDoList extends StatefulWidget {
  const MyToDoList({super.key});

  @override
  State<MyToDoList> createState() => _MyToDoListState();
}

class _MyToDoListState extends State<MyToDoList> {
  List to_do_list = ["Eating", "Smiling", "Sleeping"];

  final databaseRef = FirebaseDatabase.instance.ref('ToDoList');

  TextEditingController addcontroller = TextEditingController();
  TextEditingController editcontroller = TextEditingController();

  add_in_list() async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final title = addcontroller.text.trim();

    if (addcontroller.text.isEmpty) {
      //Alert box error
      return req_type_text_func();
    } else {
      try {
        await databaseRef.child(id).set({'id': id, 'title': title});
        addcontroller.clear();
      } catch (error) {
        debugPrint('Error adding item to list: $error');
      }
    }
  }

  delete_in_list({selected_index}) {
    setState(() {
      to_do_list.removeAt(selected_index);
    });
  }

  edit_in_Alertbox({Save_in_selected_list_index}) {
    setState(() {
      to_do_list[Save_in_selected_list_index] = editcontroller.text;
      editcontroller.clear();
    });
  }

  edit_in_selected_list(index) {
    setState(() {
      to_do_list[index] = editcontroller.text;
      editcontroller.clear();
    });
  }

  edit_in_list(index) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.amberAccent,
            title: const Text("hashir"),
            content: TextField(
              controller: editcontroller,
              decoration: InputDecoration(
                  hintText: editcontroller.text = to_do_list[index]),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    edit_in_selected_list(index);
                    Navigator.pop(context);
                  },
                  child: const Text("Save")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  req_type_text_func() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Alert",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text("Plz type text and then press ADD :)"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.blue),
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdf093),
      appBar: AppBar(
        backgroundColor: const Color(0xfffce543),
        title: TextField(
          controller: addcontroller,
          decoration: const InputDecoration(hintText: "Type here Text"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              add_in_list();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff3e78d),
              foregroundColor: Colors.black,
            ),
            child: const Text("ADD"),
          )
        ],
      ),
      body: FirebaseAnimatedList(
        defaultChild: const Text('Loading'),
        query: databaseRef,
        itemBuilder: (context, snapshot, animantion, index) {
          return Container(
            margin:
                const EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: const Color(0xfffce543),
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              textColor: Colors.black,
              title: Text(snapshot.child('title').value.toString()),
              trailing: Wrap(
                children: [
                  IconButton(
                      onPressed: () {
                        delete_in_list(selected_index: index);
                      },
                      icon: const Icon(Icons.delete_outline_sharp)),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                      //Edit icon biutton
                      onPressed: () {
                        edit_in_list(index);
                      },
                      icon: const Icon(
                        Icons.edit_outlined,
                        shadows: [Shadow(offset: Offset(1, 1), blurRadius: 1)],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
