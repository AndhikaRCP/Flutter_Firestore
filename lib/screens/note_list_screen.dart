import 'package:flutter/material.dart';
import 'package:notes/services/note_service.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          confirmDialog(context);
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  void confirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Content merupakan isi utama dari dialog
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add'),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Title:',
                  textAlign: TextAlign.start,
                ),
              ),
              TextField(
                controller: _titlecontroller,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Description:',
                  textAlign: TextAlign.start,
                ),
              ),
              TextField(
                controller: _descriptioncontroller,
              ),
            ],
          ),
          // Action berisi kumpulan button
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ),
            ElevatedButton(
                onPressed: () {
                  // Map<String, dynamic> newNote = {};
                  // ini adalah alternatif dari yang di atas
                  // Map<String, dynamic> newNote =
                  //     new Map<String, dynamic>();

                  // Cara jika belum memisahkan service dan front end
                  // newNote['title'] = _titlecontroller.text;
                  // newNote['description'] = _descriptioncontroller.text;

                  // FirebaseFirestore.instance
                  //     .collection('notes')
                  //     .add(newNote)
                  //     .whenComplete(() {
                  //   Navigator.of(context).pop();
                  // });

                  NoteService.addNote(
                          _titlecontroller.text, _descriptioncontroller.text)
                      .whenComplete(() => Navigator.of(context).pop());

                  _titlecontroller.clear();
                  _descriptioncontroller.clear();
                },
                child: const Text('Save')),
          ],
        );
      },
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
                      showDataDialog(context, document);
                    },
                    title: Text(document['title']),
                    subtitle: Text(document['description']),
                    trailing: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Column(
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

  void showDataDialog(BuildContext context, Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titlecontroller =
            TextEditingController(text: document['title']);
        TextEditingController descriptioncontroller =
            TextEditingController(
                text: document['description']);
        return AlertDialog(
          title: const Text('Update Notes'),
          // Content merupakan isi utama dari dialog
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title:',
                textAlign: TextAlign.start,
              ),
              TextField(
                controller: titlecontroller,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  'Description:',
                  textAlign: TextAlign.start,
                ),
              ),
              TextField(
                controller: descriptioncontroller,
              ),
            ],
          ),
          // Action berisi kumpulan button
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
                  // Map<String, dynamic> updateNote = {};
                  // ini adalah alternatif dari yang di atas
                  // Map<String, dynamic> newNote =
                  //     new Map<String, dynamic>();
                  // updateNote['title'] = titlecontroller.text;
                  // updateNote['description'] =
                  //     descriptioncontroller.text;
                  // FirebaseFirestore.instance
                  //     .collection('notes')
                  //     .doc(document.id)
                  //     .update(updateNote)
                  //     .whenComplete(() {
                  //   Navigator.of(context).pop();
                  // });
    
                  NoteService.updateNote(
                          document['id'],
                          titlecontroller.text,
                          descriptioncontroller.text)
                      .whenComplete(
                          () => Navigator.of(context).pop());
                  titlecontroller.clear();
                  descriptioncontroller.clear();
                },
                child: const Text('Update')),
          ],
        );
      },
    );
  }
}
