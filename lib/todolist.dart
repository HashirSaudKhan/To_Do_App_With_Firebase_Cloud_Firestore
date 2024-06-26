// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyToDoList extends StatefulWidget {
  const MyToDoList({super.key});

  @override
  State<MyToDoList> createState() => _MyToDoListState();
}

class _MyToDoListState extends State<MyToDoList> {
  CollectionReference fireStoreref =
      FirebaseFirestore.instance.collection('users');

  final fireStoreSnapshot =
      FirebaseFirestore.instance.collection('users').snapshots();

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
        // await databaseRef.child(id).set({'id': id, 'title': title});
        await fireStoreref.doc(id).set({'id': id, 'title': title});
        addcontroller.clear();
      } catch (error) {
        debugPrint('Error adding item to list: $error');
      }
    }
  }

  delete_in_list(String id) async {
    fireStoreref.doc(id).delete();
  }

  edit_in_list(String title, String id) async {
    editcontroller.text = title;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.amberAccent,
            title: const Text("Update"),
            content: TextField(
              controller: editcontroller,
              decoration: InputDecoration(hintText: editcontroller.text),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    fireStoreref.doc(id).update({
                      'title': editcontroller.text.toLowerCase(),
                    });
                    // databaseRef.child(id).update({
                    //   'title': editcontroller.text.toLowerCase(),
                    // });
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
        body: StreamBuilder<QuerySnapshot>(
          stream: fireStoreSnapshot,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Some Error');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContextcontext, index) {
                final id = snapshot.data!.docs[index]['id'].toString();
                final title = snapshot.data!.docs[index]['title'].toString();
                return Container(
                  margin: const EdgeInsets.only(
                      left: 18, right: 18, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xfffce543),
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    textColor: Colors.black,
                    title: Text(snapshot.data!.docs[index]['title'].toString()),
                    // title: Text(snapshot.child('title').value.toString()),
                    trailing: Wrap(
                      children: [
                        IconButton(
                            onPressed: () {
                              delete_in_list(id);
                            },
                            icon: const Icon(Icons.delete_outline_sharp)),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            //Edit icon biutton
                            onPressed: () {
                              edit_in_list(title, id);
                            },
                            icon: const Icon(
                              Icons.edit_outlined,
                              shadows: [
                                Shadow(offset: Offset(1, 1), blurRadius: 1)
                              ],
                            )),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
