import 'package:flutter/material.dart';
import 'package:notes/services/note_service.dart';
import 'package:notes/widgets/note_dialog.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return NoteDialog();
              });
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NoteService.getNoteList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Errorr : ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.only(bottom: 80),
              // children: snapshot.data!.doc.map((document) {
              children: snapshot.data!.map((document) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NoteDialog(
                              note: document,
                            );
                          });
                    },
                    title: Text(document['title']),
                    subtitle: Text(document['description']),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Column(
                                children: [
                                  Text('Apakah Anda ingin Menghapus Data ?'),
                                ],
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel')),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      // FirebaseFirestore.instance
                                      //     .collection('notes')
                                      //     .doc(document.id)
                                      //     .delete()
                                      //     .catchError((e) {
                                      //   print(e);
                                      // });
                                      NoteService.deleteNote(
                                        document['id'],
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Delete')),
                              ],
                            );
                          },
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}